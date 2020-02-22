require_relative 'lib/basic_temperature/version'

Gem::Specification.new do |spec|
  spec.name          = "basic_temperature"
  spec.version       = BasicTemperature::VERSION
  spec.authors       = ["Marian Kostyk"]
  spec.email         = ["mariankostyk13895@gmail.com"]

  spec.summary       = %q{Value object for basic temperature operations.}
  spec.description   = %q{Value object for basic temperature operations like conversions from Celcius to Fahrenhait or Kelvin etc.}
  spec.homepage      = "https://github.com/marian13/basic_temperature"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
