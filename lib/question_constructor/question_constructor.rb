class QuestionConstructor

  class StrategyMissingError < RuntimeError; end

  attr_reader :references
  attr_accessor :strategy

  def initialize(user, question, strategy = nil)
    @user = user
    @question = question
    @strategy = strategy || question.suggested_strategy
    @references = {}
  end

  include Enumerable
  def each &block
    if block
      @references.each_value do |reference_definition|
        block.call(reference_definition.reference)
      end
    else
      @references.values.map(&:reference).to_enum
    end
  end
  alias_method :each_reference, :each

  def all
    self.each_reference.to_a
  end
  alias_method :to_a, :all

  def generate_references
    if @strategy
      @strategy.new(@user, @question, @references).generate_references
    else
      raise StrategyMissingError, 'a strategy has not been specified'
    end
  end

  def [] reference_name
    @references.fetch(reference_name.to_sym) { |r| 
      raise ArgumentError, "#{r} is not defined as a reference in #{@strategy.name}" 
    }.reference
  end

  def include?(key)
    @references.key?(key)
  end
  alias_method :has?, :include?

  def to_partial_path
    # facilitate rendering constructor 
    'question_constructor/question_constructor'
  end

  def reference_fields(builder)
    self.each_with_object([]).with_index do |(ref, html), i|
      html << ref.hidden_fields(builder, "_#{i}")
    end.join.html_safe
  end
end