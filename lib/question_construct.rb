class QuestionConstruct
  class Construct
    attr_accessor :pool, :main, :models, :column

    def table
      main.class.table_name
    end

    def to_partial_path
      "constructs/#{table}/#{table.singularize}"
    end

  end

  class Column
    def initialize(obj, name)
      @object = obj
      @name = name

      @value = obj.send(name)
    end

    def table
      @object.class.table_name
    end

    def to_partial_path
      "constructs/#{table}/#{@name}"
    end

    def method_missing(meth, *args, &block)
      @value.send(meth, *args, &block)
    end

  end

  # a class responsible for building the questions
  # and its context given a questions construct meta

  attr_reader :user, :question, :constructs
  def initialize(user, question)
    @user, @question = user, question
    @constructs = {}.with_indifferent_access
  end


  def parse_meta(key)

    top_level_hash = @question.construct_meta.with_indifferent_access
    sub_level_hashes = [top_level_hash.fetch(key)].flatten
    sub_level_hashes.each do |sub_level_hash|
      parse_sub_hash(top_level_hash, sub_level_hash, key).tap do |construct|
        @constructs[key] ||= [] 
        @constructs[key] << construct
        define_singleton_method key do
          @constructs[key]
        end
      end
    end
    self
  end

  def parse_sub_hash(top_level_hash, sub_level_hash, key)
    construct = Construct.new

    sub_level_hash = self.class.complete_sub_level_hash!(top_level_hash, sub_level_hash)

    construct.models = sub_level_hash[:models].map { |m| Kernel.const_get(m) }

    temp_pools = construct.models.map do |model|
      pool = if sub_level_hash[:scopes].any?
                sub_level_hash[:scopes].inject(model) do |inner_pool ,(scope, args)|
                  inner_pool.send(scope, *parse_args(args))
                end
              else
                model
              end
      pool.unreferenced(user: @user, question: @question)
    end

    construct.pool = temp_pools.inject {|r, second_r| r.to_a.concat(second_r.to_a).uniq  }
    construct.main = construct.pool.sample

    binding.pry if construct.main.nil?

    construct.column = Column.new(construct.main, sub_level_hash[:column])

    construct
  end

  def parse_args(args)
    args = [args].flatten
    args.map do |arg|
      if /%\((?<eval_str>\w+)\)/ =~ arg
        @constructs[eval_str].first.main
      else
        arg
      end
    end
  end

  def has? key
    @constructs.key? key
  end

  def self.complete_sub_level_hash!(top_level_hash, sub_level_hash)
    sub_level_hash[:column] ||= top_level_hash[:column]
    sub_level_hash[:scopes] ||= {}
    sub_level_hash[:scopes].merge!(top_level_hash[:scopes])
    sub_level_hash[:models] = [sub_level_hash[:models]].flatten
    sub_level_hash
  end

  def to_partial_path
    "constructs/construct"
  end

end