Dir.glob(File.join(__dir__, 'constructor', '*.rb')) do |file|
  require file
end

class QuestionConstructor
  # a class responsible for building the questions
  # and its context given a questions construct meta
  attr_reader :user, :question, :constructs

  def initialize(user, question)
    @user, @question = user, question
    @constructs = {}.with_indifferent_access
  end

  def construct(key)
    top_level_hash = @question.construct_meta.with_indifferent_access
    sub_level_hashes = [top_level_hash.fetch(key)].flatten
    sub_level_hashes.each do |sub_level_hash|  
      @constructs[key] = parse_sub_hash(top_level_hash, sub_level_hash, key)
      define_singleton_method key do
        @constructs[key]
      end
    end
    self
  end

  def reference_fields(builder)
    builder.fields_for("references_attributes[]", builder.object.references.new) do |sub_builder|
      @constructs.inject('') do |html, (_, construct)|        
        html + construct.to_fields(sub_builder)
      end.html_safe
    end.html_safe
  end

  def has? construct
    @constructs.key? construct
  end

  def to_partial_path
    "constructs/construct"
  end

  private

    def parse_sub_hash(top_level_hash, sub_level_hash, key)
      construct = Construct.new(key)

      sub_level_hash = complete_sub_level_hash!(top_level_hash, sub_level_hash)

      construct.models = sub_level_hash[:models].map { |m| Kernel.const_get(m) }

      temp_pools = construct.models.map do |model|

        if sub_level_hash[:scopes].any?
          sub_level_hash[:scopes].inject(model) do |inner_pool ,(scope, args)|
            inner_pool.send(scope, *parse_args(args))
          end
        else
          model
        end
      end

      construct.pool = temp_pools.inject do |last_pool, pool| 
        last_pool.to_a.concat(pool.to_a)
      end
      
      construct.main = construct.pool.sample

      construct.column = sub_level_hash[:column] && Column.new(construct.main, sub_level_hash[:column])

      construct
    end

    def parse_args(args)
      args = [args].flatten
      args.map do |arg|
        case arg
        when String
          handle_interpolation(arg)
        when Hash
          {}.tap do |h|
            arg.each do |key, val|
              if val.is_a? Array
                h[key] = parse_args(val)
              elsif val.is_a? Hash
                h[key] = parse_args(val)
              else
                h[key] = handle_interpolation(val)
              end
            end
          end
        end
      end
    end

    def handle_interpolation(str)
      if /%\((?<meta_char>[#:])(?<meta_word>\w+)\)/ =~ str
        case meta_char
        when '#'
          # reference a method
          send(meta_word)
        when ':'
          # reference a construct
          @constructs[meta_word].main
        end
      else
        str
      end
    end

    def complete_sub_level_hash!(top_level_hash, sub_level_hash)
      sub_level_hash[:column] ||= top_level_hash[:column]
      sub_level_hash[:scopes] ||= {}
      sub_level_hash[:scopes].merge!(top_level_hash[:scopes]) unless top_level_hash[:scopes].nil?
      sub_level_hash[:models] = [sub_level_hash[:models]].flatten
      sub_level_hash
    end

end