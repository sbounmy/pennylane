# frozen_string_literal: true

require "test_helper"

class ProductTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end
  class ListTest < ProductTest
    test "#list" do
      products = Pennylane::Product.list
      assert products.count > 1
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        Pennylane::Product.list
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      products = Pennylane::Product.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
      assert products.count > 0
    end

    test 'accepts page' do
      list = Pennylane::Product.list(page: 2)
      assert_equal 0, list.products.count
    end

    test 'can iterate' do
      Pennylane::Product.list.each do |product|
        assert product.is_a? Pennylane::Product
      end
    end

  end

  class RetrieveTest < ProductTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        Pennylane::Product.retrieve('not_found')
      end
    end

    test "return object when found" do
      prod = Pennylane::Product.retrieve('fee')
      assert_equal 'Frais de service', prod.label
      assert_equal 'fee', prod.id
    end

    test "raise error on unknown attribute" do
      prod = Pennylane::Product.retrieve('fee')
      assert_raises NoMethodError do
        prod.sexy_name
      end
    end

  end

  class CreateTest < ProductTest
    test 'create product' do
      product = Pennylane::Product.create label: 'New product', unit: 'Tesla', price: 40, vat_rate: 'FR_200', currency: 'EUR'
      expected = Pennylane::Product.list(filter: [{field: 'label', operator: 'eq', value: 'New product'}]).first
      assert_equal expected.source_id, product.source_id
      assert_equal 'New product', expected.label
    end

    test 'raise error on missing fields product' do
      assert_raises Pennylane::Error do
        Pennylane::Product.create label: 'New product'
      end
    end
  end

  class UpdateTest < ProductTest
    test 'update product attributes' do
      n = rand.to_s[2..4]
      before = Pennylane::Product.retrieve('fee')
      before.update description: "Platform fee #{n}"
      after = Pennylane::Product.retrieve('fee')

      assert_equal before.source_id, after.source_id
      assert_equal "Platform fee #{n}", after.description
      assert_equal "Platform fee #{n}", before.description
    end

    test 'fails when trying to update restricted attribute' do
      omit 'should raise something if attributes if not defined but API does not return an error'
      before = Pennylane::Product.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')
      assert_raises NoMethodError do
        before.update unknown: 'something'
      end
    end
  end

end