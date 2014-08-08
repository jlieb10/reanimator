class Question < ActiveRecord::Base
  # these will translate to scopes named 
  # #expects_radio, #expects_checkbox etc.
  # and boolean helpers named #expects_radio?, #expects_checkbox? etc.
  BASE_EXPECTATIONS       = %w( none radio select checkbox )
  VALID_EXPECTATIONS_ENUM = BASE_EXPECTATIONS.map { |f| "expects_#{f}" }
  enum :expectation => VALID_EXPECTATIONS_ENUM

  validates :content, :task_id, :expectation, :presence => true
  validates :expectation, :inclusion => VALID_EXPECTATIONS_ENUM

  belongs_to :task

  def expectation= val
    # facilitatie the assignment of expectations
    # ei.
    # question.expectation = :none
    # question.expectation = :radio
    val = "expects_#{val}" if BASE_EXPECTATIONS.include? val.to_s
    super(val)
  end
end
