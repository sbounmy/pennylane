module Pennylane
  class ListObject < Pennylane::Object
    include Enumerable

    def self.object_name
      'list'
    end

    def self.build_from(response, params = {}, opts = {})
      new.initialize_from_response(response)
    end

    def each(&blk)
      data.each(&blk)
    end

    def data
      @values[key_for(@values)]
    end

    def key_for(resp)
      resp.keys.find { |k| Pennylane::API_RESOURCES.keys.include?(Util.singularize(k.to_s)) } || resp.keys.find { |k| resp[k].is_a? Array }
    end

  end
end