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
      Reference.new(@role).tap do |ref|
        ref.object = @pool_block.call.sample # FIXME: Is there a better way to do this?
      end
    end

    def method_missing(name, *args, &block)
      if @strategy.references.key? name
        @stategy.references[name]
      else
        super
      end
    end
  end
end