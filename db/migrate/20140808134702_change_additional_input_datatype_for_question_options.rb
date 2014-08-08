class ChangeAdditionalInputDatatypeForQuestionOptions < ActiveRecord::Migration
  def up
    change_column :question_options, :additional_input, :integer, :default => 0
  end

  def down
    change_column :question_options, :additional_input, :boolean, :default => false
  end
end
