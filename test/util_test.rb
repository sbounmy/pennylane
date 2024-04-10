# frozen_string_literal: true

require "test_helper"

module Pennylane
  class UtilTest < Test::Unit::TestCase
    setup do
    end
    class ConvertToPennylaneObjectTest < UtilTest
      test "turn list to ListObjects" do
        obj = Util.convert_to_pennylane_object({'total_pages' => 1, '_object' => 'list', 'customers' => [{'name' => 'LUCKYSPACE', '_object' => 'customer'}]})
        assert obj.is_a? Pennylane::ListObject
      end

      test 'turn object to PennylaneObject'  do
        obj = Util.convert_to_pennylane_object({'customer' => {'name' => 'LUCKYSPACE', '_object' => 'customer'}, 'some_other_key' => 'value', '_object' => 'customer'})
        assert obj.is_a? Pennylane::Customer
      end

      test 'faillback to Object when missing object'  do
        obj = Util.convert_to_pennylane_object({'customer' => {'name' => 'LUCKYSPACE'}})
        assert obj.is_a? Pennylane::Object
      end

      test 'turn array items to PennylaneObject'  do
        obj = Util.convert_to_pennylane_object({'total_pages' => 1, '_object' => 'list', 'customers' => [{'name' => 'LUCKYSPACE', '_object' => 'customer' }]})
        assert obj.customers[0].is_a? Pennylane::Customer
        assert_equal 'LUCKYSPACE', obj.customers[0].name
      end

      test 'can overwrite config api key' do
      end

      test 'accepts filter' do
      end
    end

    class NormalizeResponseTest < UtilTest
      test "inject list when array" do
        obj = Util.normalize_response({'total_pages' => 1, 'customers' => [{'name' => 'LUCKYSPACE'}]})
        assert_equal 'list', obj['_object']
        assert_equal 'customer', obj['customers'][0]['_object']
      end

      test 'inject object name when single item'  do
        obj = Util.normalize_response({'customer' => {'name' => 'LUCKYSPACE'}})
        assert_equal 'customer', obj['customer']['_object']
        assert_equal 'customer', obj['_object']
      end

      test 'inject object name when two items'  do
        obj = Util.normalize_response({'customer' => {'name' => 'LUCKYSPACE'}, 'some_other_key' => 'value'})
        assert_equal 'customer', obj['customer']['_object']
        assert_equal 'customer', obj['_object']
      end

      test 'inject object name when nested item'  do
        obj = Util.normalize_response({'customer' => {'name' => 'LUCKYSPACE', 'billing_address' => { 'address' => 'Paris'}}, 'some_other_key' => 'value'})
        assert_equal 'customer', obj['_object']
        assert_equal 'customer', obj['customer']['_object']
        assert_equal 'billing_address', obj['customer']['billing_address']['_object']
      end

      test 'fallbacks to object if not a defined class'  do
        obj = Util.normalize_response({'total_pages' => 1, 'some-objects' => [{'name' => 'LUCKYSPACE'}]})
        assert_equal 'list', obj['_object']
        assert_equal 'some-object', obj['some-objects'][0]['_object']
      end
    end

  end
end