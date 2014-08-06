class Question < ActiveRecord::Base
  VALID_EXPECTATIONS = %w( text multiple single  )

  validates :content, :task_id, :expectation, :presence => true
  validates :expectation, :inclusion => VALID_EXPECTATIONS

  belongs_to :task
end
