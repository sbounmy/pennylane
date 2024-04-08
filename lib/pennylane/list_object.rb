module Pennylane
  class ListObject < Pennylane::Object
    include Enumerable

    def self.build_from(response, params = {}, opts = {})
      new.initialize_from_response(response)
    end

    def each(&blk)
      data.each(&blk)
    end

    def data
      @values[Util.key_for(@values)]
    end
  end
end