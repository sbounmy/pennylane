module Pennylane
  class CategoryGroup < Resources::Base

    class << self

      def object_name
        'category_group'
      end

      def list filters = {}, opts = {}
        request_pennylane_object(method: :get, path: "/category_groups", params: { query: filters }, opts: opts)
      end
    end

  end
end