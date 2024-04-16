# frozen_string_literal: true

require "test_helper"

class CustomerInvoiceTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end

  def line_items
    [{label: 'Demo label', quantity: 1, currency_amount: 10_00, unit: 'piece', vat_rate: 'FR_200'}]
  end

  def draft
    customer_params = { name: 'Tesla', customer_type: 'company', address: '4 rue du faubourg', postal_code: '75001', city: 'Paris', country_alpha2: 'FR' }
    date = Date.today
    deadline = Date.today >> 1

    @draft ||= Pennylane::CustomerInvoice.create  create_customer: true, create_products: true,
                                                  invoice: { date: date, deadline: deadline, draft: true,
                                                   customer: customer_params,
                                                   line_items: line_items
                                              }

  end
  class ListTest < CustomerInvoiceTest
    test "#list" do
      invoices = Pennylane::CustomerInvoice.list
      assert invoices.count > 13
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        Pennylane::CustomerInvoice.list
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      invoices = Pennylane::CustomerInvoice.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
      assert invoices.count > 13
    end

    test 'accepts filter' do
      list = Pennylane::CustomerInvoice.list(filter: [{field: 'label', operator: 'eq', value: 'Facture Stephane Bounmy - F-2022-14 (label généré)'}])

      assert_equal 1, list.invoices.count
      assert_equal "Facture Stephane Bounmy - F-2022-14 (label généré)", list.invoices[0].label
    end

    test 'can iterate' do
      Pennylane::CustomerInvoice.list.each do |invoice|
        puts invoice.inspect
        assert invoice.is_a? Pennylane::CustomerInvoice
      end
    end

    test 'has other attributes' do
      invoices = Pennylane::CustomerInvoice.list
      assert invoices.total_pages > 1
      assert invoices.total_invoices > 13
      assert_equal 1, invoices.current_page
    end
  end

  class RetrieveTest < CustomerInvoiceTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        Pennylane::CustomerInvoice.retrieve('not_found')
      end
    end

    test "return object when found" do
      invoice = Pennylane::CustomerInvoice.retrieve('OJRX1PO8OC')
      puts invoice.inspect
      assert_equal 'Facture Stephane Bounmy - F-2022-14 (label généré)', invoice.label
      assert_equal 'OJRX1PO8OC', invoice.id
    end

    test "raise error on unknown attribute" do
      cus = Pennylane::CustomerInvoice.retrieve('OJRX1PO8OC')
      assert_raises NoMethodError do
        cus.sexy_name
      end
    end
  end

  class CreateTest < CustomerInvoiceTest
    test 'create invoice' do

      assert_difference -> { Pennylane::CustomerInvoice.list.total_invoices }, 1 do
        draft
        assert_not_nil draft.id
        assert_equal 'Demo label', draft.line_items[0].label
      end
    end
  end

  class UpdateTest < CustomerInvoiceTest
    test 'update invoice attributes' do
      assert_difference -> { Pennylane::CustomerInvoice.retrieve(draft.id).line_items.length }, 1 do
        draft.update line_items: line_items
      end
      assert_equal 2, draft.line_items.length
    end

    test 'fails when trying to update restricted attribute' do
      omit 'should raise something if attributes if not defined but API does not return an error'
      before = Pennylane::CustomerInvoice.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')
      assert_raises NoMethodError do
        before.update unknown: 'something'
      end
    end
  end
end