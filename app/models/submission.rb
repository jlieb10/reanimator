class Submission < ActiveRecord::Base
  # -------------------------------------
  # | id | user_id | question_option_id |
  # -------------------------------------

  belongs_to :user
  belongs_to :question_option
  has_many   :references

  # needs validation that is scoped to question_option, and references
end
