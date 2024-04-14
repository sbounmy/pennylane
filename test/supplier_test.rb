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
      puts suppliers.inspect
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
      assert_equal "Homebox", list.suppliers[0].name
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
end