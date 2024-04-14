module Pennylane
  module Resources
    class Base < Pennylane::Object
      class << self

        def object_name
          name&.split('::')&.last&.downcase
        end

        def object_name_plural
          "#{object_name}s"
        end

        def request_pennylane_object(method:, path:, params: {}, opts: {}, usage: [])
          resp, opts = execute_resource_request(method, path, params, opts, usage)
          Util.convert_to_pennylane_object(Util.normalize_response(resp), params, opts)
        end

        def execute_resource_request(method, path, params = {}, opts = {}, usage = [])
          api_key = opts.delete(:api_key) || Pennylane.api_key


          resp = client.request(
            method,
            path,
            params: params,
            opts: opts
          )

          [JSON.parse(resp.read_body), opts]
        end

        def client
          @client ||= Pennylane::Client.new(Pennylane.api_key)
        end

        def normalize_filters(filters)
          filters[:filter] = filters[:filter].to_json if filters[:filter]
          filters
        end
      end

      # So we can call directly method on the object rather than going through his key
      # Pennylane::Customer.retrieve('any-id').name == Pennylane::Customer.retrieve('any-id').customer.name
      def method_missing(method_name, *args, &block)
        obj = @values[self.class.object_name.to_sym]
        raise NoMethodError, "undefined method `#{method_name}` for #{self.class}" unless obj
        obj.send(method_name, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        @values[self.class.object_name.to_sym].respond_to?(method_name) || super
      end

    end
  end
end