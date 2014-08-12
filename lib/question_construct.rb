class QuestionConstruct
  class Construct
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
        define_singleton_method "#{key}_construct" do
          @constructs[key]
        end
      end
    end
    self
  end

  def parse_sub_hash(top_level_hash, sub_level_hash, key)
    cache_var = "@#{key}".to_sym

    construct = Construct.new

    sub_level_hash = self.class.complete_sub_level_hash!(top_level_hash, sub_level_hash)


    models = sub_level_hash[:models].map { |m| Kernel.const_get(m) }
    construct.instance_variable_set("#{cache_var}_models", models)

    temp_pools = models.map do |model|
      pool = if sub_level_hash[:scopes].present?
                sub_level_hash[:scopes].inject(model) do |inner_pool ,(scope, args)|
                  inner_pool.send(scope, *parse_args(args))
                end
              else
                model
              end
      pool.unreferenced(user: @user, question: @question)
    end

    pool = temp_pools.inject {|r, second_r| r.to_a & second_r.to_a  }

    construct.instance_variable_set("#{cache_var}_pool", pool)
    construct.instance_variable_set(cache_var, pool.sample)
  

    construct.instance_variable_set("#{cache_var}_column", sub_level_hash[:column])

    # define singleton readers
    str_for_attr_reader = 
      [key, "#{key}_models", "#{key}_pool", "#{key}_column"].map { |m| m.to_sym.inspect }.join(', ')
    construct.instance_eval <<-CODE
      class << self
        attr_reader(#{str_for_attr_reader})
      end
    CODE
    construct
  end

  def parse_args(args)
    args = [args].flatten
    args.map do |arg|
      if /%\((?<eval_str>.+)\)/ =~ arg
        @constructs[eval_str].first.send(eval_str)
      else
        arg
      end
    end
  end

  def self.complete_sub_level_hash!(top_level_hash, sub_level_hash)
    sub_level_hash[:column] ||= top_level_hash[:column]
    sub_level_hash[:scopes] ||= {}
    sub_level_hash[:scopes].merge!(top_level_hash[:scopes])
    sub_level_hash[:models] = [sub_level_hash[:models]].flatten
    sub_level_hash
  end
end