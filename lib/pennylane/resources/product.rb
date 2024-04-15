module Pennylane
  class Product < Resources::Base

    class << self

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/products", params: { query: filters }, opts: opts)
      end

      def retrieve customer_id, opts = {}
        request_pennylane_object(method: :get, path: "/products/#{customer_id}", params: {}, opts: opts)
      end

      def create params, opts = {}
        request_pennylane_object(method: :post, path: "/products", params: { body: { product: params } }, opts: opts)
      end

    end

  end
end