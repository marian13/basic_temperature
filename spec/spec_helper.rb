if ENV['REVERSE_COVERAGE']
  require_relative 'reverse_coverage_helper'
else
  require_relative 'coverage_helper'
end

require 'bundler/setup'
require 'basic_temperature'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
