class QuestionConstructor

  attr_reader :references

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
    @strategy.new(@user, @question, @references).generate_references
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

  def reference_fields(builder, input_type = :hidden)
    self.each_with_object([]).with_index do |(ref, html), i|
      # FIXME: move to reference model
      html << builder.fields_for("reference_attributes[]", ref) do |r_builder|
        r_builder.send("#{input_type}_field", :role, :id => "reference_role_#{i}") +
        r_builder.send("#{input_type}_field", :referenced_type, :id => "reference_referenced_type_#{i}") +
        r_builder.send("#{input_type}_field", :referenced_nid, :id => "reference_referenced_nid_#{i}") +
        r_builder.send("#{input_type}_field", :column_name, :id => "reference_column_name_#{i}")
      end.html_safe
    end.join.html_safe
  end
end