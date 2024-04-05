module Pennylane
  class Customer < Resources::Base
    def self.list filters = {}, opts = {}
      request_pennylane_object(method: :get, path: "/v1/customers", params: filters, opts: opts)
    end
  end
end