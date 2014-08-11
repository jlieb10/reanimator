class AddQuestionIdAndOptionIdToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :question_id, :integer, :index => true
    add_column :submissions, :option_id, :integer, :index => true
  end
end
