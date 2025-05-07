# frozen_string_literal: true

require_relative "lib/readme_yard/version"

Gem::Specification.new do |spec|
  spec.name = "readme_yard"
  spec.version = ReadmeYard::VERSION
  spec.authors = ["Matt Ruzicka"]
  spec.license = "MIT"

  spec.summary = "Build a better README with YARD."
  spec.homepage = "https://github.com/mattruzicka/readme_yard"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = ReadmeYard::DOCS_URL

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir = "bin"
  spec.executables = ["readme"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "diffy", "~> 3.4"
  spec.add_dependency "tty-markdown", "~> 0.7"
  spec.add_dependency "yard", "~> 0.9"
  spec.add_dependency "yard-readme", "~> 0.5"

  spec.add_development_dependency "irb"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
