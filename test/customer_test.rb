# frozen_string_literal: true

require "test_helper"

class CustomerTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end
  class ListTest < CustomerTest
    test "#list" do
      customers = Pennylane::Customer.list
      assert_equal 13, customers['customers'].count
      assert_equal 13, customers.customers.count
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        Pennylane::Customer.list
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      customers = Pennylane::Customer.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
      assert_equal 13, customers['customers'].count
    end

    test 'accepts filter' do
      customers = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'LUCKYSPACE'}].to_json)
      assert_equal 1, customers.customers.count
      assert_equal "LUCKYSPACE", customers.customers[0].name
    end
  end

  class RetrieveTest < CustomerTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        Pennylane::Customer.retrieve('not_found')
      end
    end

    test "return object when found" do
      cus = Pennylane::Customer.retrieve('d9add8c6-3520-41a3-99c8-f54da7dd4d11')
      puts cus.inspect
      assert_equal 'LUCKYSPACE', cus.customer.name
    end
  end
end