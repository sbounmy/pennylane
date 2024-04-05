# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Test::Unit::TestCase
  test ".api_key" do
    Pennylane.api_key = 'my-token-api-key'
    assert_equal 'my-token-api-key', Pennylane.api_key
  end
end