# frozen_string_literal: true

require_relative "../lib/sale_engine"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
