# DOCS: https://github.com/colszowka/simplecov
# DOCS: https://docs.coveralls.io/ruby-on-rails
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])

SimpleCov.start do
  add_filter '/spec/'
end

# NOTE: `basic_temperature/version.rb` is ignored intentionally.
# See https://github.com/colszowka/simplecov/issues/557
