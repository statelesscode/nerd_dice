# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

require "bundler/setup"
require "nerd_dice"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# called by ConvenienceMethods specs testing for bonus mismatch between kwargs and method_name
def get_bonus_error_message(keyword, modifier)
  "Bonus integrity failure: Modifier specified in keyword arguments was #{keyword}. " \
    "Modifier specified in method_name was #{modifier}."
end
