module Amy
  class Application
    def dispatch(env)
      return not_found if env["PATH_INFO"] == "/favicon.ico"
      klass, action = get_controller_and_action(env)

      controller = klass.new(env)
      return not_found_page unless controller.respond_to?(action)

      controller.make_response_for action
    end

    def get_controller_and_action(env)
      _, controller, action, after = env["PATH_INFO"].split('/', 4)
      controller.capitalize!

      [Object.const_get(controller + 'Controller'), action]
    end
  end
end