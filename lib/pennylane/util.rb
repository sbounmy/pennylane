module Pennylane
  class Util

    class << self
      def convert_to_pennylane_object(resp, params={}, opts={})
        case resp
        when Array
          resp.map { |value| convert_to_pennylane_object(value, params, opts) }
        when Hash
          resp.each do |key, value|
            resp[key] = convert_to_pennylane_object(value, params, opts)
          end
          klass_for(resp['_object']).build_from(resp, params, opts)
        else
          resp
        end
      end

      # This method is used to normalize the response from the API
      # It will add an _object key to each hash in the response
      # This key will contain the name of the object
      # It will also add an _object key to the root of the response
      # with: is used to map the object name to a different class
      # Example : GET /customer_invoices will return a list of invoices
      #  {
      #   "total_pages": 5,
      #   "current_page": 1,
      #   "total_invoices": 12,
      #   "invoices": []
      # }
      # `invoices` should be `customer_invoice` so we can cast it to the right class CustomerInvoice
      # Since we don't have the ability to change the API response.
      # We can achieve this by calling normalize_response(response, with: {invoice: 'customer_invoice'})
      def normalize_response(object, with={})
        # puts object.inspect
        case object
        when Hash
          new_hash = {}
          new_hash['_object'] = object.has_key?('total_pages') ? 'list' : (with[singularize(object.keys.first).to_sym] || singularize(object.keys.first))
          object.each do |key, value|
            if value.is_a? Array
              new_hash[key] = value.map do |h|
                h['_object'] = with[singularize(key).to_sym] || singularize(key) if h.is_a? Hash
                normalize_response(h, with)
              end
            elsif value.is_a? Hash
              value['_object'] = with[singularize(key).to_sym] || singularize(key)
            end
            new_hash[key] = normalize_response(value, with)
          end
          new_hash
        when Array
          object.map do |value|
            normalize_response(value, with)
          end
        else
          object
        end
      end

      def file(file_path)
        file_data = File.open(file_path).read
        Base64.strict_encode64(file_data)
      end

      # This method is used to convert the keys of a hash from strings to symbols
      def symbolize_names(object)
        case object
        when Hash
          new_hash = {}
          object.each do |key, value|
            key = (begin
                     key.to_sym
                   rescue StandardError
                     key
                   end) || key
            new_hash[key] = symbolize_names(value)
          end
          new_hash
        when Array
          object.map { |value| symbolize_names(value) }
        else
          object
        end
      end

      def klass_for(object)
        Pennylane::API_RESOURCES[singularize(object)] || Pennylane::Object
      rescue
        Pennylane::Object
      end

      # We define our own singularize method because the ActiveSupport one is too heavy for this use case
      def singularize(word)
        return word if word.empty?

        # Basic rules: this is far from comprehensive and handles only simple and common cases
        if word.end_with?('ies')
          word.sub(/ies$/, 'y')
        elsif word.end_with?('ss') # so `address` dont become `addres`
          word
        elsif word.end_with?('s')
          word.chomp('s')
        else
          word
        end
      end
    end
  end
end