# frozen_string_literal: true

require "test_helper"

class PennylaneTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Pennylane.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
