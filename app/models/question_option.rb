class QuestionOption < ActiveRecord::Base
  belongs_to :question
  belongs_to :option

  # an option can only belong to a question once
  validates :option_id, :uniqueness => { :scope => :question_id }
end
