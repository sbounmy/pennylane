# frozen_string_literal: true

require "test_helper"

module Pennylane
  class UtilTest < Test::Unit::TestCase
    setup do
    end
    class ConvertToPennylaneObjectTest < UtilTest
      test "turn list to ListObjects" do
        obj = Util.convert_to_pennylane_object({'total_pages' => 1, 'customers' => [{'name' => 'LUCKYSPACE'}]})
        assert obj.is_a? Pennylane::ListObject
      end

      test 'turn object to PennylaneObject'  do
        obj = Util.convert_to_pennylane_object({'customer' => {'name' => 'LUCKYSPACE'}, 'some_other_key' => 'value'})
        assert obj.is_a? Pennylane::Customer
      end

      test 'can overwrite config api key' do
      end

      test 'accepts filter' do
      end
    end

    class KeyFor < UtilTest
      test 'return the resource key plural' do
        obj = {'total_pages' => 1, 'customers' => [{'name' => 'LUCKYSPACE'}]}
        assert_equal 'customers', Util.key_for(obj)
      end

      test 'return the resource key' do
        obj = {'total_pages' => 1, 'customer' => {'name' => 'LUCKYSPACE'}}
        assert_equal 'customer', Util.key_for(obj)
      end

      test 'return the resource key even if resource is not defined' do
        omit 'todo'
        obj = {'total_pages' => 1, 'anyobject' => {'name' => 'LUCKYSPACE'}}
        assert_equal 'anyboject', Util.key_for(obj)
      end

    end
  end
end