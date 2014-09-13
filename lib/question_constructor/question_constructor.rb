class QuestionConstructor

  attr_reader :references

  def initialize(user, question, strategy = nil)
    @user = user
    @question = question
    @strategy = strategy || question.suggested_strategy
    @references = {}
  end

  def generate_references
    @strategy.new(@user, @question, @references).generate_references
  end

  def [] reference_name
    @references.fetch(reference_name.to_sym) { |r| 
      raise ArgumentError, "#{r} is not defined as a reference in #{@strategy.name}" 
    }.reference
  end
end