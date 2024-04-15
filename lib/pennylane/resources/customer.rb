module Pennylane
  class Customer < Resources::Base

    class << self

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/customers", params: { query: filters }, opts: opts)
      end

      def retrieve id, opts = {}
        request_pennylane_object(method: :get, path: "/customers/#{id}", params: {}, opts: opts)
      end

      def create params, opts = {}
        request_pennylane_object(method: :post, path: "/customers", params: { body: { customer: params } }, opts: opts)
      end

    end

  end
end