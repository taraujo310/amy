# frozen_string_literal: true
# require "byebug"
require "rack"
require_relative "amy/version"
require_relative "amy/routing"
require_relative "amy/util"
require_relative "amy/dependencies"
require_relative "amy/controller"
require_relative "amy/file_model"
require_relative "author"

DEFAULT_HEADER = { 'content-type' => 'text/html' }

module Amy
  class Application
    def call(env)
      return respond!(get_root_static_file) if env["PATH_INFO"] == "/"
      dispatch(env)
    end

    def respond!(body, status = nil, headers = nil)
      status  ||= 200
      headers ||= DEFAULT_HEADER

      headers.delete("content-length")

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
  end
end