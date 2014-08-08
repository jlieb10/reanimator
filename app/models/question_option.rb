class QuestionOption < ActiveRecord::Base
  # these will translate to scopes named 
  # #requires_no_input, #requires_text, #requires_image etc.
  # and boolean helpers named #requires_no_input?, #requires_text?, #requires_image? etc.
  ADDITIONAL_DATATYPES = %w( no_input image text ).map { |i| "requires_#{i}" }

  enum :additional_input => ADDITIONAL_DATATYPES

  belongs_to :question
  belongs_to :option

  # an option can only belong to a question once
  validates :option_id, :uniqueness => { :scope => :question_id }
end
