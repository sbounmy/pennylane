# frozen_string_literal: true

require "test_helper"

class SupplierTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end

  class ListTest < SupplierTest
    test "#list" do
      suppliers = Pennylane::Supplier.list
      assert suppliers.count > 13
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        Pennylane::Supplier.list
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      suppliers = Pennylane::Supplier.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
      assert suppliers.count > 13
    end

    test 'accepts page' do
      list = Pennylane::Supplier.list(page: 2)
      assert list.suppliers.count > 1
    end

    test 'can iterate' do
      Pennylane::Supplier.list.each do |supplier|
        assert supplier.is_a? Pennylane::Supplier
      end
    end

    test 'has other attributes' do
      suppliers = Pennylane::Supplier.list
      assert suppliers.total_pages > 2
      assert suppliers.total_suppliers > 13
      assert_equal 1, suppliers.current_page
    end
  end

  class RetrieveTest < SupplierTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        Pennylane::Supplier.retrieve('not_found')
      end
    end

    test "return object when found" do
      sup = Pennylane::Supplier.retrieve('f44d50ac-f3f5-48cb-903a-30fdbcecaf2b')
      assert_equal 'Frais kilométriques', sup.name
      assert_equal 'f44d50ac-f3f5-48cb-903a-30fdbcecaf2b', sup.id
    end

  end

  class UpdateTest < SupplierTest
    test 'update supplier attributes' do
      vat = "FR#{rand.to_s[2..12]}"
      before = Pennylane::Supplier.retrieve('f44d50ac-f3f5-48cb-903a-30fdbcecaf2b')
      before.update vat_number: vat
      after = Pennylane::Supplier.retrieve('f44d50ac-f3f5-48cb-903a-30fdbcecaf2b')

      assert_equal before.source_id, after.source_id
      assert_equal 'Frais kilométriques', after.name
      assert_equal vat, after.vat_number
      assert_equal vat, before.vat_number
    end

    test 'raise API error when is not valid' do
      assert_raises Pennylane::Error do
        Pennylane::Supplier.retrieve('f44d50ac-f3f5-48cb-903a-30fdbcecaf2b').update vat_number: 'invalid'
      end
    end
  end

  class CreateTest < SupplierTest
    test 'create supplier' do
      customer = Pennylane::Supplier.create name: 'Apple Inc', address: '4 rue du faubourg', postal_code: '75008', city: 'Paris', country_alpha2: 'FR'
      expected = Pennylane::Supplier.list(filter: [{field: 'name', operator: 'eq', value: 'Apple Inc'}]).first
      assert_equal expected.source_id, customer.source_id
      assert_equal 'Apple Inc', expected.name
      assert_equal '4 rue du faubourg', expected.billing_address.address
    end
  end

end