class ChangeAdditionalInputDatatypeForQuestionOptions < ActiveRecord::Migration
  def up
    remove_column :question_options, :additional_input
    add_column :question_options, :additional_input, :integer, :default => 0
  end

  def down
    remove_column :question_options, :additional_input
    add_column :question_options, :additional_input, :boolean, :default => false
  end
end
