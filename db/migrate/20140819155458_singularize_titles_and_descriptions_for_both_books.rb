class SingularizeTitlesAndDescriptionsForBothBooks < ActiveRecord::Migration
  def up
    rename_column :gutenberg_books, :titles, :title
    rename_column :oclc_books,      :titles, :title
    rename_column :oclc_books,      :descriptions, :description
  end

  def down
    rename_column :gutenberg_books, :title, :titles
    rename_column :oclc_books,      :title, :titles
    rename_column :oclc_books,      :description, :descriptions
  end
end
