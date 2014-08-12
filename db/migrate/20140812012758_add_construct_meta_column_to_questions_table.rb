class AddConstructMetaColumnToQuestionsTable < ActiveRecord::Migration
  def change
    add_column :questions, :construct_meta, :text
  end
end
