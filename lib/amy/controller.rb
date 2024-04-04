# frozen_string_literal: true

require "erubis"
require "byebug"
require "rack/request"

module Amy
  class Controller
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = { "content-type" => "text/html" })
      raise "Already responded!" if @response

      body = case text
             when File
               text
             else
               [text].flatten
             end

      @response = Rack::Response.new(body, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def make_response_for(action)
      begin
        send(action)
      rescue StandardError => e
        case e
        when NoMethodError
          response(render_static("404.html"), 404)
        else
          response("500 - Not Found", 500)
        end
      end

      get_response.to_a
    end

    def render(view_name, locals = {})
      filename  = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template  = File.read filename
      eruby     = eruby_from template

      eruby.result locals.merge(env: env)
    end

    def render_static(filename)
      if File.exist?("./public/#{filename}")
        path = "./public/#{filename}"
      elsif File.exist?(File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "public", filename)))
        path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "public", filename))
      end

      if path
        File.open(path)
      else
        get_root_static_file
      end
    end

    def get_root_static_file
      File.open("./public/index.html")
    rescue StandardError
      path = File.join(File.dirname(__FILE__), "..", "..", "public", "index.html")
      default_root_path = File.expand_path(path)

      File.open(default_root_path)
    end

    def eruby_from(template)
      eruby = Erubis::Eruby.new template

      instance_variables.each do |variable|
        eruby.instance_variable_set(variable, instance_variable_get(variable))
      end

      eruby
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")

      Amy.to_snake_case(klass)
    end
  end
end
