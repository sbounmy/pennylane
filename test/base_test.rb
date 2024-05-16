# frozen_string_literal: true

require "test_helper"

class BaseTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end

  class MethodErrorTest < BaseTest
    test 'print list of methods available on failure' do
      error = assert_raises NoMethodError do
        vcr { Pennylane::Customer.list.first.some_method_name }
      end

      assert_match /Methods available/, error.message
      assert_match /\:name/, error.message
    end
  end
end