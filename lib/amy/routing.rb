module Amy
  class Application
    def get_controller_and_action(env)
      _, controller, action, after = env["PATH_INFO"].split('/', 4)
      controller.capitalize!

      [Object.const_get(controller + 'Controller'), action]
    end
  end
end