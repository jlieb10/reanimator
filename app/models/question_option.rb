class QuestionOption < ActiveRecord::Base
  # ---------------------------------------------------
  # | id | question_id | option_id | additional_input |
  # ---------------------------------------------------

  ADDITIONAL_DATATYPES = %w( no_input image short_text long_text )
  # these enum values will translate to scopes named 
  # #require_no_input, #require_text, #require_image etc.
  # and boolean helpers named #require_no_input?, #require_text?, #require_image? etc.
  include EnumHandler
  enum(:additional_input => ADDITIONAL_DATATYPES) { |i| "require_#{i}" }

  belongs_to :question
  belongs_to :option

  # an option can only belong to a question once
  validates :option_id, :uniqueness => { :scope => :question_id }

end
