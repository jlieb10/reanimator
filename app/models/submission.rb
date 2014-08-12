class Submission < ActiveRecord::Base
  # ------------------------------------------
  # | id | user_id | question_id | option_id |
  # ------------------------------------------

  belongs_to :user
  belongs_to :question
  belongs_to :option
  has_many   :references

  validates_presence_of :question_id, :option_id, :user_id
  # validates :with => :unique_context
  # needs validation that is scoped to question_option, and references

  # a question can only be answered once per each subject
  # this is inteded to be a validation and must be worked
  def unique_context
    subject_reference = self.references.where(:role => 'subject')
    invalid_submissions = self.class.joins(:references)
                                    .where('references.role = "subject"')
                                    .where('references.referenced_type = ?', subject_reference.referenced_type)
                                    .where('references.referenced_nid = ?', subject_reference.referenced_nid)
                                    .where('submissions.question_id = ?', question_id)
                                    .group('submissions.id')
    if invalid_submissions.any?
      errors[:base] << "This question has already been answered."
    end
  end
end
