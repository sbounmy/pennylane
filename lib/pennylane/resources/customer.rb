module Pennylane
  class Customer < Resources::Base

    class << self

      def list filters = {}, opts = {}
        request_pennylane_object(method: :get, path: "/customers", params: { query: filters }, opts: opts)
      end

      def retrieve customer_id, opts = {}
        request_pennylane_object(method: :get, path: "/customers/#{customer_id}", params: {}, opts: opts)
      end

      def create params, opts = {}
        request_pennylane_object(method: :post, path: "/customers", params: { body: { customer: params } }, opts: opts)
      end
    end

  end
end