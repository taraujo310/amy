# frozen_string_literal: true

require_relative "amy/version"
require_relative "author"

module Amy
  class Application
    def call(env)
      [200, { 'content-type' => 'text/html' }, [
        "Hello, Amy!"
        ]]
    end
  end
end