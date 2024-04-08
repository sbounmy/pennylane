module Pennylane
  class Util

    class << self
      def convert_to_pennylane_object(resp, params={}, opts={})
        if resp.has_key? 'total_pages'
          # convert list items to existing Resource object, if none Generic Pennylane::Object is initialized
          resp[Util.key_for(resp)] = resp[Util.key_for(resp)].map { |i| convert_to_pennylane_object(i, params, opts) }
          Pennylane::ListObject.build_from(resp, params, opts)
        else
          key = key_for(resp)
          case resp[key]
          # when Array
          #   Pennylane::ListObject.build_from(resp[key].map { |i| convert_to_pennylane_object(i, params, opts) })
          when Hash
            Pennylane::Resources::Base.descendant_names.fetch(key).build_from(resp[key], params, opts)
          else
            resp
          end

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
        resp.keys.find { |k| Resources::Base.descendant_names.keys.include?(singularize(k.to_s)) }
      end

      # We define our own singularize method because the ActiveSupport one is too heavy for this use case
      def singularize(word)
        return word if word.empty?

        # Basic rules: this is far from comprehensive and handles only simple and common cases
        if word.end_with?('ies')
          word.sub(/ies$/, 'y')
        elsif word.end_with?('s')
          word.chomp('s')
        else
          word
        end
      end
    end
  end
end