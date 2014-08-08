class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.belongs_to :question
      t.belongs_to :option

      t.boolean :additional_input, :default => false

      t.timestamps
    end
  end
end
