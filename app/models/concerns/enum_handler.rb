module EnumHandler
  extend ActiveSupport::Concern

  module ClassMethods

    def enum args={}, &block
      new_args = {}
      enum_maps = args.map do |(column, enum_values)|
        EnumMap.new(self, column).tap do |em|
          # collect the original enum values
          em.enum_values.concat(enum_values)

          # collect block with which to refine helper methods
          em.refine_methods_with(&block)

          # collect new set of arguments for previously defined
          # enum method
          new_args[column] = em.values

          # include validation for enum values
          validates_inclusion_of column, :in => enum_values
        end
      end
      super(new_args)

      enum_maps.each(&:redifine_setter_method!)
               .each(&:redifine_getter_method!)
    end

  end
end