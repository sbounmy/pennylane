module Pennylane
  class Object
    include Enumerable
    attr_reader :id

    def initialize_from_response(response, params = {}, opts = {})
      values = Util.symbolize_names(response)
      @values = self.class.send :deep_copy, values
      add_accessors(@values.keys, @values)
      @opts = opts
      self
    end

    def self.protected_fields
      []
    end

    def self.build_from(response, params = {}, opts = {})
      new.initialize_from_response(response, params, opts)
    end

    def self.objects
      {}.tap do |h|
        descendants.each do |klass|
          h[klass.object_name] = klass
        end
      end
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self && respond_to?(:object_name) }
    end

    # Eigenclass to define methods on the specific class
    protected def metaclass
      class << self; self; end
    end

    protected def add_accessors(keys, values)
      # not available in the #instance_eval below
      protected_fields = self.class.protected_fields

      metaclass.instance_eval do
        keys.each do |k|
          # next if RESERVED_FIELD_NAMES.include?(k)
          # next if protected_fields.include?(k)
          # next if @@permanent_attributes.include?(k)

          if k == :method
            # Object#method is a built-in Ruby method that accepts a symbol
            # and returns the corresponding Method object. Because the API may
            # also use `method` as a field name, we check the arity of *args
            # to decide whether to act as a getter or call the parent method.
            define_method(k) { |*args| args.empty? ? @values[k] : super(*args) }
          else
            define_method(k) { @values[k] }
          end

          define_method(:"#{k}=") do |v|
            if v == ""
              raise ArgumentError, "You cannot set #{k} to an empty string. " \
                "We interpret empty strings as nil in requests. " \
                "You may set (object).#{k} = nil to delete the property."
            end
            @values[k] = Util.convert_to_pennylane_object(v, @opts)
            dirty_value!(@values[k])
            @unsaved_values.add(k)
          end

          define_method(:"#{k}?") { @values[k] } if [FalseClass, TrueClass].include?(values[k].class)
        end
      end
    end

    # Produces a deep copy of the given object including support for arrays,
    # hashes, and Pennylane:Object.
    private_class_method def self.deep_copy(obj)
      case obj
      when Array
        obj.map { |e| deep_copy(e) }
      when Hash
        obj.each_with_object({}) do |(k, v), copy|
          copy[k] = deep_copy(v)
          copy
        end
      when Pennylane::Object
        obj.class.build_from(
          deep_copy(obj.instance_variable_get(:@values)),
          obj.instance_variable_get(:@opts).select do |k, _v|
            Util::OPTS_COPYABLE.include?(k)
          end
        )
      else
        obj
      end
    end
  end
end