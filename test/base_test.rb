# frozen_string_literal: true

require "test_helper"

class BaseTest < Test::Unit::TestCase
  setup do
  end
  class DescendantNamesTest < BaseTest
    test "#descendant_names" do
      assert_equal ['customer'], Pennylane::Resources::Base.descendant_names
    end
  end
end