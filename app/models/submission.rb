class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :question_option
  
  has_many :references_nid
  # needs validation that is scoped to question_option, and references
end
