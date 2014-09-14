class Question < ActiveRecord::Base
  # -----------------------------------------------------------------------------------
  # | id | task_id | content | expectation | created_at | updated_at | construct_meta |
  # -----------------------------------------------------------------------------------

  VALID_EXPECTATIONS = %w( none radio select checkbox )
  # these enum translate to scopes named 
  # #expects_radio, #expects_checkbox etc.
  # and boolean helpers named #expects_radio?, #expects_checkbox? etc.
  include EnumHandler
  enum(:expectation => VALID_EXPECTATIONS) { |f| "expects_#{f}" }

  validates_presence_of :content, :task_id, :expectation

  belongs_to :task
  has_many   :question_options
  has_many   :options, :through => :question_options

  serialize :construct_meta

  def suggested_strategy
    "#{self.task.name.gsub(' ', '')}Strategy".constantize rescue nil
  end
end
