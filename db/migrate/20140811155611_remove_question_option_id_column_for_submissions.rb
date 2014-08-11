class RemoveQuestionOptionIdColumnForSubmissions < ActiveRecord::Migration
  def up
    remove_column :submissions, :question_option_id
  end

  def down
    add_column :submissions, :question_option_id, :integer
  end
end
