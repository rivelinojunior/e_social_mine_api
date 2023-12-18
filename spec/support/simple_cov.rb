# frozen_string_literal: true

require 'simplecov'
require 'simplecov-json'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter]
)

SimpleCov.start 'rails' do
  enable_coverage :branch
  add_group 'Services', 'app/services'
end
