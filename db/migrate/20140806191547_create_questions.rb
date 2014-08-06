class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content

      # represented as enum
      t.integer :expectation

      t.belongs_to :task, :index => true

      t.timestamps
    end
  end
end
