class QuestionConstructor

  class Construct

    attr_accessor :pool, :main, :models, :column

    def initialize(role)
      @role = role.to_s.singularize.to_sym
    end

    def table
      main.class.table_name
    end

    def to_partial_path
      "constructs/#{table}/#{table.singularize}"
    end

    def to_s
      main.to_s
    end

    def reference_attributes
      {
        referenced_nid: main.nid,
        referenced_type: main.class.name,
        column_name: column.name,
        role: @role
      }
    end

    def to_stubbed_fields(builder)
      reference_attributes.inject('') do |html, (name)|
        html + builder.hidden_field(name)
      end
    end

    def to_fields(builder)
      reference_attributes.inject('') do |html, (name, value)|
        html + builder.hidden_field(name, value: value)
      end
    end

    def method_missing(meth, *args, &block)
      if @main.respond_to? meth
        @main.send(meth)
      else
        super
      end
    end
    
  end
end