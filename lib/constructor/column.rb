class QuestionConstructor

  class Column
    attr_reader :name, :value

    def initialize(obj, name)
      @object = obj
      @name = name
      @value = @object.send(@name)
    end

    def table
      @object.class.table_name
    end

    def to_s
      @value.to_s
    end

    def to_partial_path
      "constructs/#{table}/#{@name}"
    end

    def method_missing(meth, *args, &block)
      # forward messages to value variable
      # look into Fowardable module
      if self.value.respond_to? meth
        self.value.send(meth, *args, &block)
      else
        super
      end
    end

  end
end