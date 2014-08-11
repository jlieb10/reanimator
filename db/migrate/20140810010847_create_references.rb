class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :referenced_type
      t.string :referenced_nid
      t.string :column_name

      t.integer :submission_id
      t.timestamps
    end
  end
end
