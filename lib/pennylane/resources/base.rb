module Pennylane
  module Resources
    class Base < Pennylane::Object
      include HTTParty
      base_uri 'app.pennylane.com/api/external'

      class << self

        def object_name
          name&.split('::')&.last&.downcase
        end

        def object_name_plural
          "#{object_name}s"
        end

        def request_pennylane_object(method:, path:, params:, opts: {}, usage: [])
          resp, opts = execute_resource_request(method, path, params, opts, usage)
          Util.convert_to_pennylane_object(Util.normalize_response(resp), params, opts)
        end

        def execute_resource_request(method, url, params = {}, opts = {}, usage = [])
          api_key = opts.delete(:api_key) || Pennylane.api_key

          resp = self.send method, url, query: params, headers: { "Authorization": "Bearer #{api_key}" }.merge(opts)

          handle_error_response(resp) if should_handle_as_error?(resp.code)

          [resp.parsed_response, opts]
        end

        private

        def handle_error_response(resp)
          case resp.code
          when 401
            raise Pennylane::AuthenticationError, resp.body
          when 404
            raise Pennylane::NotFoundError
          else
            raise Pennylane::Error, resp.parsed_response['message'] || resp.parsed_response['error']
          end
        end

        def should_handle_as_error?(code)
          code >= 400
        end

      end
    end
  end
end