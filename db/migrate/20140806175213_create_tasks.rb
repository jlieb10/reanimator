class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name

      # represented as enum
      t.integer :category
      
      t.integer :point_value, :default => 0
    end
  end
end
