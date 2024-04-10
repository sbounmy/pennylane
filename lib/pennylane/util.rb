module Pennylane
  class Util

    class << self
      def convert_to_pennylane_object(resp, object_name=nil, params={}, opts={})
        object_name ||= key_for(resp)
        if resp.has_key? 'total_pages'
          # convert list items to existing Resource object, if none Generic Pennylane::Object is initialized
          resp[object_name] = resp[object_name].map { |i| convert_to_pennylane_object(i, singularize(object_name), params, opts) }
          puts convert_to_pennylane_object(resp[Util.key_for(resp)][0], {}, {}).inspect
          Pennylane::ListObject.build_from(resp, params, opts)
        else
          # key = key_for(resp)
          object_resp = resp[object_name] || resp
          case
          # when Array
          #   Pennylane::ListObject.build_from(resp[key].map { |i| convert_to_pennylane_object(i, params, opts) })
          when Hash
            Pennylane::Resources::Base.descendant_names.fetch(object_name).build_from(object_resp, params, opts)
          else
            resp
          end

        end
      end

      # This method is used to normalize the response from the API
      # It will add an _object key to each hash in the response
      # This key will contain the name of the object
      # It will also add an _object key to the root of the response
      def normalize_response(object)
        case object
        when Hash
          new_hash = {}
          new_hash['_object'] = object.has_key?('total_pages') ? 'list' : singularize(object.keys.first)

          object.each do |key, value|
            if value.is_a? Array
              value.each do |h|
                h['_object'] = singularize(key)
              end
            elsif value.is_a? Hash
              value['_object'] = singularize(key)
            end
            new_hash[key] = normalize_response(value)
          end
          new_hash
        when Array
          object.map do |value|
            normalize_response(value)
          end
        else
          object
        end
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

      def key_for(resp)
        resp.keys.find { |k| Resources::Base.descendant_names.keys.include?(singularize(k.to_s)) } || resp.keys.find { |k| resp[k].is_a? Array }
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