class Submission < ActiveRecord::Base
  # ------------------------------------------
  # | id | user_id | question_id | option_id |
  # ------------------------------------------

  belongs_to :user
  belongs_to :question
  belongs_to :option
  has_many   :references

  accepts_nested_attributes_for :references

  validates_presence_of :question_id, :option_id, :user_id
  # needs validation that is scoped to question_option, and references
  
end
