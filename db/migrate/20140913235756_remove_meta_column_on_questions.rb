class RemoveMetaColumnOnQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :construct_meta
  end
end
