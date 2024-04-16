module Pennylane
  class CustomerInvoice < Resources::Base

    class << self

      def object_name
        'customer_invoice'
      end

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/customer_invoices", params: { query: filters }, opts: opts, with: { invoice: 'customer_invoice' })
      end

      def retrieve id, opts = {}
        request_pennylane_object(method: :get, path: "/customer_invoices/#{id}", params: {}, opts: opts, with: { invoice: 'customer_invoice' })
      end

      def create params, opts = {}
        request_pennylane_object(method: :post, path: "/customer_invoices", params: { body: params }, opts: opts, with: { invoice: 'customer_invoice' })
      end

    end

    # since object name is different from the class name, we need to override the method
    def update(attributes)
      resp, opts = self.class.request_pennylane_object(method: :put, path: "/#{self.class.object_name_plural}/#{id}",
                                                       params: { body: { 'invoice' => attributes } },
                                                       opts: {}, with: { invoice: 'customer_invoice' })
      @values = resp.instance_variable_get :@values
      self
    end

    # since object name is different from the class name, we need to override the object_name method
    def object
      @values[:invoice]
    end

    # doesnt have a `source_id` so we override it
    def id
      object.id
    end

  end
end