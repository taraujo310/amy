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

    def make_response_for(action)
      status = 200

      begin
        body = [self.send(action)]
      rescue NoMethodError => e
        status = 404
        body = ['404 - Not Found']
      rescue => e
        puts e.inspect

        status = 500
        body = ['500 - Internal Server Error']
      end

      { status: status, body: body }
    end

    def render(view_name, locals = {})
      filename  = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template  = File.read filename
      eruby     = eruby_from template

      eruby.result locals.merge(:env => env)
    end

    def eruby_from(template)
       eruby     = Erubis::Eruby.new template

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