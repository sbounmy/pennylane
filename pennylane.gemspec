# frozen_string_literal: true

require_relative "lib/pennylane/version"

Gem::Specification.new do |spec|
  spec.name = "pennylane"
  spec.version = Pennylane::VERSION
  spec.authors = ["Stephane Bounmy"]
  spec.email = ["159814+sbounmy@users.noreply.github.com"]

  spec.summary = "Ruby bindings for the Pennylane API"
  spec.description = "Pennylane offers integrated financial management and accounting tools for businesses. See https://pennylane.com for details."
  spec.homepage = "https://rubygems.org/gems/pennylane"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sbounmy/pennylane"
  spec.metadata["changelog_uri"] = "https://github.com/sbounmy/pennylane/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency "vcr", "~> 6.2"
  spec.add_development_dependency "test-unit", "~> 3.6"
  spec.add_development_dependency "minitest", "~> 5.22"
  spec.add_dependency "httparty", "~> 0.21.0"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end