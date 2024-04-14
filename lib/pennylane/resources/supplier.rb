module Pennylane
  class Supplier < Resources::Base
    class << self

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/suppliers", params: { query: filters }, opts: opts)
      end

      def retrieve supplier_id, opts = {}
        request_pennylane_object(method: :get, path: "/suppliers/#{supplier_id}", params: {}, opts: opts)
      end

    end
  end
end