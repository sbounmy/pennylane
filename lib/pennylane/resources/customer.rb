module Pennylane
  class Customer < Resources::Base

    class << self

      def list filters = {}, opts = {}
        request_pennylane_object(method: :get, path: "/v1/customers", params: filters, opts: opts)
      end

      def retrieve customer_id, opts = {}
        request_pennylane_object(method: :get, path: "/v1/customers/#{customer_id}", params: {}, opts: opts)
      end
    end

  end
end