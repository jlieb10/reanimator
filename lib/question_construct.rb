class QuestionConstruct
  # a class responsible for building the questions
  # and its context given a questions construct meta

  def initialize(user, question)
    @user, @question = user, question
  end


  def parse_meta(key, cache_var = nil)
    cache_var ||= "@#{key}".to_sym

    top_level_hash = @question.construct_meta.with_indifferent_access
    sub_level_hash = self.class.complete_sub_level_hash!(top_level_hash, top_level_hash[key])

    _temp_pool = nil

    instance_variable_set("#{cache_var}_model", const_get(sub_level_hash[:models].sample)).tap do |model|
      _temp_pool =  if sub_level_hash[:scopes].present?
                      subject_hash[:scopes].inject(model) do |pool ,(scope, args)|
                        args = [args].flatten
                        pool.send(scope, *args)
                      end
                    else
                      model
                    end
    end

    instance_variable_set("#{cache_var}_pool", _temp_pool).tap do |pool|
      instance_variable_set(cache_var, pool)
    end
  end

  def self.complete_sub_level_hash!(top_level_hash, sub_level_hash)
    sub_level_hash[:column] ||= top_level_hash[:column]
    sub_level_hash[:scopes] ||= top_level_hash[:scopes]
    sub_level_hash[:models] = [sub_level_hash[:models]].flatten
    sub_level_hash
  end
end