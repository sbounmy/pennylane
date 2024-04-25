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

    # since object name is different from the class name, we need to override the object_name method
    def object
      @values[:invoice]
    end

    # doesnt have a `source_id` so we override it
    def id
      object.id
    end

    # API CALLS

    # since object name is different from the class name, we need to override the method
    def update(attributes)
      resp, opts = self.class.request_pennylane_object(method: :put,
                                                       path: "/customer_invoices/#{id}",
                                                       params: { body: { 'invoice' => attributes } },
                                                       opts: {}, with: { invoice: 'customer_invoice' })
      @values = resp.instance_variable_get :@values
      self
    end

    def finalize
      request_and_retrieve(method: :put, path: "/customer_invoices/#{id}", action: 'finalize')
    end

    def mark_as_paid
      resp, opts = self.class.request_pennylane_object(method: :put,
                                          path: "/customer_invoices/#{id}/mark_as_paid",
                                          params: {},
                                          opts: {}, with: { invoice: 'customer_invoice' })
      @values = resp.instance_variable_get :@values
      self
    end

    def send_by_email
      request_and_retrieve(method: :post, path: "/customer_invoices/#{id}", action: 'send_by_email')
    end

    private

    # When API returns an empty body
    # so we need to skip values assignment from the response
    # GET /customer_invoices/:id again to get the updated values
    def request_and_retrieve(method:, path:, action:)
      self.class.request_pennylane_object(method: method,
                                          path: "#{path}/#{action}",
                                          params: {},
                                          opts: {}, with: { invoice: 'customer_invoice' })
      resp, opts = self.class.request_pennylane_object(method: :get,
                                                       path: path,
                                                       params: {},
                                                       opts: {}, with: { invoice: 'customer_invoice' })
      @values = resp.instance_variable_get :@values
      self
    end
  end
end