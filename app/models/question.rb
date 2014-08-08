class Question < ActiveRecord::Base
  # these will translate to scopes named 
  # #expects_radio, #expects_checkbox etc.
  # and boolean helpers named #expects_radio?, #expects_checkbox? etc.
  VALID_EXPECTATIONS = %w( radio checkbox text_area text_field  ).map { |f| "expects_#{f}" }
  enum :expectation => VALID_EXPECTATIONS

  validates :content, :task_id, :expectation, :presence => true
  validates :expectation, :inclusion => VALID_EXPECTATIONS

  belongs_to :task
end
