# frozen_string_literal: true
require "byebug"
require "rack"
require_relative "amy/version"
require_relative "amy/routing"
require_relative "author"

DEFAULT_HEADER = { 'content-type' => 'text/html' }

module Amy
  class Application
    def call(env)
      return respond!(get_root_static_file) if env["PATH_INFO"] == "/"

      status, body = dispatch(env).values_at(:status, :body)
      respond!(body, status)
    end

    def dispatch(env)
      return not_found if env["PATH_INFO"] == "/favicon.ico"

      klass, action = get_controller_and_action(env)

      controller = klass.new(env)
      return not_found_page unless controller.respond_to?(action)

      controller.make_response_for action
    end

    def respond!(body, status = nil, headers = nil)
      status  ||= 200
      headers ||= DEFAULT_HEADER

      [status, headers, body]
    end

    def get_root_static_file
      begin
        File.open('./public/index.html')
      rescue
        path = File.join(File.dirname(__FILE__), "..", "public", "index.html")
        default_root_path = File.expand_path(path)

        File.open(default_root_path)
      end
    end

    def not_found
      { status: 404, body: [] }
    end

    def not_found_page
      begin
        File.open('./public/404.html')
      rescue
        path = File.join(File.dirname(__FILE__), "..", "public", "404.html")
        default_root_path = File.expand_path(path)

        { status: 404, body: File.open(default_root_path)}
      end
    end
  end

  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def make_response_for(action)
      begin
        body = [self.send(action)]
      rescue
        status = 500
        body = '500 - Internal Server Error'
      end

      { status: status, body: body }
    end
  end
end