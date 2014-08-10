class EnumMap
  # Simple construct to handle enum values
  attr_reader :enum_values, :block
  def initialize klass, column
    @class       = klass
    @column      = column
    @enum_values = []
    @block       = nil
  end

  def refine_methods_with &block
    @block = block
  end

  def values
    @values ||= enum_values.map { |k| @block[k] }
  end

  def redifine_setter_method!
    tap do |em|
      @class.send(:define_method, "#{@column}=") do |val|
        val = em.block[val] if em.enum_values.include? val.to_s
        super(val)
      end
    end
  end

  def redifine_getter_method!
    tap do |em|
      @class.send(:define_method, @column) do
        old_val = super()
        case old_val
        when Integer
          em.enum_values[old_val]
        when String, Symbol
          em.enum_values.find { |ev| em.block[ev] == old_val  }
        end
      end
    end
  end
end