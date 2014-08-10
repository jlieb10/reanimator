class Question < ActiveRecord::Base
  # ------------------------------------------------------------------
  # | id | task_id | content | expectation | created_at | updated_at |
  # ------------------------------------------------------------------

  # these will translate to scopes named 
  # #expects_radio, #expects_checkbox etc.
  # and boolean helpers named #expects_radio?, #expects_checkbox? etc.
  BASE_EXPECTATIONS       = %w( none radio select checkbox )
  VALID_EXPECTATIONS_ENUM = BASE_EXPECTATIONS.map { |f| "expects_#{f}" }
  enum :expectation => VALID_EXPECTATIONS_ENUM

  validates_presence_of  :content, :task_id, :expectation
  validates_inclusion_of :expectation, :in => VALID_EXPECTATIONS_ENUM

  belongs_to :task
  has_many   :question_options
  has_many   :options, :through => :question_options

  def expectation= val
    # facilitatie the assignment of expectations
    # ei.
    # question.expectation = :none
    # question.expectation = :radio
    val = "expects_#{val}" if BASE_EXPECTATIONS.include? val.to_s
    super(val)
  end
end
