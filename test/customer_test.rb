# frozen_string_literal: true

require "test_helper"

class CustomerTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end
  class ListTest < CustomerTest
    test "#list" do
      customers = Pennylane::Customer.list
      assert customers.count > 13
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
      assert customers.count > 13
    end

    test 'accepts filter' do
      list = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'LUCKYSPACE'}].to_json)
      assert_equal 1, list.customers.count
      assert_equal "LUCKYSPACE", list.customers[0].name
    end

    test 'can iterate' do
      Pennylane::Customer.list.each do |customer|
        assert customer.is_a? Pennylane::Customer
      end
    end

    test 'has other attributes' do
      customers = Pennylane::Customer.list
      assert customers.total_pages > 2
      assert customers.total_customers > 13
      assert_equal 1, customers.current_page
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
      assert_equal 'LUCKYSPACE', cus.name
    end

    test "raise error on unknown attribute" do
      cus = Pennylane::Customer.retrieve('d9add8c6-3520-41a3-99c8-f54da7dd4d11')
      assert_raises NoMethodError do
        cus.sexy_name
      end
    end
  end

  class CreateTest < CustomerTest
    test 'create customer' do
      customer = Pennylane::Customer.create customer_type: 'company', name: 'Tesla', address: '4 rue du faubourg', postal_code: '75008', city: 'Paris', country_alpha2: 'FR'
      expected = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'Tesla'}].to_json).first

      assert_equal expected.source_id, customer.source_id
      assert_equal 'Tesla', expected.name
      assert_equal '4 rue du faubourg', expected.billing_address.address
    end
  end
end