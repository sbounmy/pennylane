# frozen_string_literal: true

require "test_helper"

class CustomerInvoiceTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end

  def line_items_params
    [{label: 'Demo label', quantity: 1, currency_amount: 10_00, unit: 'piece', vat_rate: 'FR_200'}]
  end

  def customer_params
    { name: 'Tesla', customer_type: 'company', address: '4 rue du faubourg', postal_code: '75001', city: 'Paris', country_alpha2: 'FR', emails: ['stephane+tesla@hackerhouse.paris'] }
  end

  def draft invoice_params ={}
    date = Date.today
    deadline = Date.today >> 1

    @draft ||= Pennylane::CustomerInvoice.create  create_customer: true, create_products: true,
                                                  invoice: { date: date, deadline: deadline, draft: true,
                                                   customer: customer_params,
                                                   line_items: line_items_params
                                              }.merge(invoice_params)

  end
  class ListTest < CustomerInvoiceTest
    test "#list" do
      invoices = vcr { Pennylane::CustomerInvoice.list }
      assert invoices.count > 13
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        vcr { Pennylane::CustomerInvoice.list }
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      invoices = vcr { Pennylane::CustomerInvoice.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs') }
      assert invoices.count > 13
    end

    test 'accepts filter' do
      list = vcr { Pennylane::CustomerInvoice.list(filter: [{field: 'label', operator: 'eq', value: 'Facture Stephane Bounmy - F-2022-14 (label généré)'}]) }

      assert_equal 1, list.invoices.count
      assert_equal "Facture Stephane Bounmy - F-2022-14 (label généré)", list.invoices[0].label
    end

    test 'can iterate' do
      vcr do
        Pennylane::CustomerInvoice.list.each do |invoice|
          assert invoice.is_a? Pennylane::CustomerInvoice
        end
      end
    end

    test 'has other attributes' do
      invoices = vcr { Pennylane::CustomerInvoice.list }
      assert invoices.total_pages > 1
      assert invoices.total_invoices > 13
      assert_equal 1, invoices.current_page
    end
  end

  class RetrieveTest < CustomerInvoiceTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        vcr { Pennylane::CustomerInvoice.retrieve('not_found') }
      end
    end

    test "return object when found" do
      invoice = vcr { Pennylane::CustomerInvoice.retrieve('OJRX1PO8OC') }
      assert_equal 'Facture Stephane Bounmy - F-2022-14 (label généré)', invoice.label
      assert_equal 'OJRX1PO8OC', invoice.id
    end

    test "raise error on unknown attribute" do
      cus = vcr { Pennylane::CustomerInvoice.retrieve('OJRX1PO8OC') }
      assert_raises NoMethodError do
        cus.sexy_name
      end
    end
  end

  class CreateTest < CustomerInvoiceTest
    test 'create invoice' do
      vcr do
        assert_difference -> { Pennylane::CustomerInvoice.list.total_invoices }, 1 do
          draft
          assert_not_nil draft.id
          assert_equal 'Demo label', draft.line_items[0].label
        end
      end
    end
  end

  class UpdateTest < CustomerInvoiceTest
    test 'update invoice attributes' do
      vcr do
        assert_difference -> { Pennylane::CustomerInvoice.retrieve(draft.id).line_items.length }, 1 do
          draft.update line_items: line_items_params
        end
      end
      assert_equal 2, draft.line_items.length
    end

    test 'fails when trying to update restricted attribute' do
      omit 'should raise something if attributes if not defined but API does not return an error'
      before = vcr { Pennylane::CustomerInvoice.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc') }
      assert_raises NoMethodError do
        before.update unknown: 'something'
      end
    end
  end

  class FinalizeTest < CustomerInvoiceTest
    test 'success with draft' do
      vcr do
        assert_changes -> {  Pennylane::CustomerInvoice.retrieve(draft.id).status }, from: 'draft', to: 'upcoming' do
          draft.finalize
          assert_equal 'upcoming', draft.status
        end
      end
    end
  end

  class MarkAsPaidTest < CustomerInvoiceTest

    test 'success with upcoming' do
      vcr do
        draft.finalize
        assert_changes -> { Pennylane::CustomerInvoice.retrieve(draft.id).status }, from: 'upcoming', to: 'paid' do
          draft.mark_as_paid
          assert_equal 'paid', draft.status
        end
      end
    end

    test 'error with draft' do
      assert_raises Pennylane::Error do
        vcr { draft.mark_as_paid }
      end
    end

  end

  class SendByEmailTest < CustomerInvoiceTest

    test '204 response' do
      vcr do
        invoice = draft(draft: false)
        sleep 5 # wait for the pdf to be generated
        assert_nothing_raised do
          invoice.send_by_email
        end
      end
    end

    test 'error with draft' do
      assert_raises Pennylane::Error do
        vcr { draft.send_by_email }
      end
    end

  end

  class LinksTest < CustomerInvoiceTest

    test 'success when invoice with credit' do
      vcr do
        invoice1 = Pennylane::CustomerInvoice.list.first
        invoice2 = draft(draft: false, line_items: [{label: 'Credit', quantity: 1, currency_amount: -33, unit: 'piece', vat_rate: 'FR_200'}])

        assert_nothing_raised do
          links = Pennylane::CustomerInvoice.links(invoice1.quote_group_uuid, invoice2.quote_group_uuid, opts: { 'test': '1' })
          assert_equal invoice1.quote_group_uuid, links.quote_group_uuid
        end
      end
    end

  end

  class ImportTest < CustomerInvoiceTest

    test 'success with payload and pdf' do
      assert_raises Pennylane::Error, '422 - The pdf received at params[:file] already exists in the application on another invoice (other invoice id: QAO77PXGHO)' do
        vcr do
          Pennylane::CustomerInvoice.import(file: Pennylane::Util.file(File.expand_path('../fixtures/files/invoice.pdf', __FILE__)),
                                          create_customer: true,
                                          invoice: { date: Date.today, deadline: Date.today >> 1,
                                                     customer: customer_params,
                                                     line_items: line_items_params })
        end
      end
    end

  end
end