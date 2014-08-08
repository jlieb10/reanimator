class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :question_option
  
  # needs validation that is scoped to question_option, and references
end
