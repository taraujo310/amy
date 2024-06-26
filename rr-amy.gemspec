# frozen_string_literal: true

require_relative "lib/amy/version"

Gem::Specification.new do |spec|
  spec.name = "rr-amy"
  spec.version = Amy::VERSION
  spec.authors = ["Thiago Ururay"]
  spec.email = ["thiago@apoia.se"]

  spec.summary = "A Rack-based Web Framework for studying purposes."
  spec.description = "A Rack-based Web Framework for studying purposes."
  spec.homepage = "https://github.com/taraujo310/rr-amy"
  spec.required_ruby_version = ">= 3.1.1"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "erubis", "~> 2.0"
  spec.add_runtime_dependency "multi_json", "~> 1.0"
  spec.add_runtime_dependency "rack", "~> 3.0"
  spec.add_runtime_dependency "rackup", "~> 2.0"
  spec.add_runtime_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "rack-test", "~> 2.0"
  spec.add_development_dependency "rubocop", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
