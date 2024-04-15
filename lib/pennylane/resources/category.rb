module Pennylane
  class Category < Resources::Base

    class << self

      # override the object_name_plural method otherwise it will return 'categorys'
      def object_name_plural
        'categories'
      end

      def list filters = {}, opts = {}
        normalize_filters(filters)
        request_pennylane_object(method: :get, path: "/categories", params: { query: filters }, opts: opts)
      end

      def retrieve id, opts = {}
        request_pennylane_object(method: :get, path: "/categories/#{id}", params: {}, opts: opts)
      end

      def create params, opts = {}
        request_pennylane_object(method: :post, path: "/categories", params: { body: { object_name => params } }, opts: opts)
      end

    end

  end
end