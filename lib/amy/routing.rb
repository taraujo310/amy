module Amy
  class Application
    def get_controller_and_action(env)
      begin
        _, controller, action, after = env["PATH_INFO"].split('/', 4)
        controller.capitalize!

        [Object.const_get(controller + 'Controller'), action]
      rescue NameError => e
        return [Controller, 'not_found_page']
      end
    end
  end
end