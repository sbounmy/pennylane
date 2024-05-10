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

        def request_pennylane_object(method:, path:, params: {}, opts: {}, usage: [], with: {})
          resp, opts = execute_resource_request(method, path, params, opts, usage)
          if resp.empty?
            {}
          else
            Util.convert_to_pennylane_object(Util.normalize_response(resp, with), params, opts)
          end
        end

        def execute_resource_request(method, path, params = {}, opts = {}, usage = [])
          resp = client.request(
            method,
            path,
            params: params,
            opts: opts
          )
          [JSON.parse(resp.read_body || "{}"), opts] # in case body is nil ew return an empty hash
        end

        def client
          @client ||= {}
          @client[Pennylane.api_key] ||= Pennylane::Client.new(Pennylane.api_key)
        end

        def normalize_filters(filters)
          filters[:filter] = filters[:filter].to_json if filters[:filter]
          filters
        end
      end

      # object happens to be nil when the object is in a list
      def id
        object.source_id
      rescue
        super
      end

      # object happens to be nil when the object is the nested object
      def [](k)
        (object && object[k.to_sym]) || @values[k.to_sym]
      end

      #
      def object
        @values[self.class.object_name.to_sym]
      end

      # def inspect
      #   id_string = respond_to?(:id) && !id.nil? ? " id=#{id}" : ""
      #   "#<#{self.class}:0x#{object_id.to_s(16)}#{id_string}> JSON: " +
      #     JSON.pretty_generate(object.instance_variable_get(:@values) || @values)
      # end

      def update(attributes)
        resp, opts = self.class.request_pennylane_object(method: :put, path: "/#{self.class.object_name_plural}/#{id}", params: { body: { self.class.object_name => attributes } })
        @values = resp.instance_variable_get :@values
        self
      end

      # So we can call directly method on the object rather than going through his key
      # Pennylane::Customer.retrieve('any-id').name == Pennylane::Customer.retrieve('any-id').customer.name
      def method_missing(method_name, *args, &block)
        raise NoMethodError, "undefined method `#{method_name}` for #{self.class}.\nMethods available : #{@values.keys}" unless object
        object.send(method_name, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        object.respond_to?(method_name) || super
      end

    end
  end
end