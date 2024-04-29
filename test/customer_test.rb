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
      list = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'LUCKYSPACE'}])
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
      assert_equal 'd9add8c6-3520-41a3-99c8-f54da7dd4d11', cus.id
      assert_equal 'LUCKYSPACE', cus['name']
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
      expected = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'Tesla'}]).first
      assert_equal expected.source_id, customer.source_id
      assert_equal 'Tesla', expected.name
      assert_equal '4 rue du faubourg', expected.billing_address.address
    end
  end

  class UpdateTest < CustomerTest
    test 'update customer attributes' do
      postal_code = rand.to_s[2..6]
      before = Pennylane::Customer.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')
      before.update postal_code: postal_code, city: 'Paris', country_alpha2: 'FR'
      after = Pennylane::Customer.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')

      assert_equal before.source_id, after.source_id
      assert_equal 'Tesla', after.name
      assert_equal postal_code, after.billing_address.postal_code
      assert_equal postal_code, before.billing_address.postal_code
    end

    test 'fails when trying to update restricted attribute' do
      omit 'should raise something if attributes if not defined but API does not return an error'
      before = Pennylane::Customer.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')
      assert_raises NoMethodError do
        before.update unknown: 'something'
      end
    end
  end
end