class QuestionConstructor
  
  class ReferenceDefinition

    def self.define role, strategy, *vars, &block
      self.new(role, strategy).tap { |rd| rd.instance_exec(*vars, &block) }
    end

    def initialize role, strategy
      @role = role
      @strategy = strategy
    end

    def column name
      @column = name
    end

    def pool &block
      @pool_block = block 
    end

    def reference
      object = @pool_block.call.sample # FIXME: Is there a better way to do this?
      Reference.new(:role => @role, :referenced => object, :column_name => @column)
    end

    def method_missing(name, *args, &block)
      if @strategy.references.key? name
        @strategy.references[name].reference.referenced
      else
        super
      end
    end
  end
end