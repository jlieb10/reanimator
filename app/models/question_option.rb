class QuestionOption < ActiveRecord::Base
  # these will translate to scopes named 
  # #requires_no_input, #requires_text, #requires_image etc.
  # and boolean helpers named #requires_no_input?, #requires_text?, #requires_image? etc.
  BASE_ADDITIONAL_DATATYPES = %w( no_input image short_text long_text )
  ADDITIONAL_DATATYPES_ENUM = BASE_ADDITIONAL_DATATYPES.map { |i| "requires_#{i}" }

  enum :additional_input => ADDITIONAL_DATATYPES_ENUM

  belongs_to :question
  belongs_to :option

  # an option can only belong to a question once
  validates :option_id, :uniqueness => { :scope => :question_id }

  def additional_input= val
    # facilitatie the assignment of additional_input
    # ie.
    # question_option.additional_input = :image
    # question_option.additional_input = :short_text
    val = "requires_#{val}" if BASE_ADDITIONAL_DATATYPES.include? val.to_s
    super(val)
  end
end
