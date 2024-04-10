# frozen_string_literal: true

require "test_helper"

class BaseTest < Test::Unit::TestCase
  setup do
  end
  class ObjectNamesTest < BaseTest
    test "returns camelcase names" do
      assert_equal ['customer'], Pennylane::Resources::Base.object_names
    end
  end
end