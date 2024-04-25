# frozen_string_literal: true

require "test_helper"

class PennylaneTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Pennylane.const_defined?(:VERSION)
    end
  end
end