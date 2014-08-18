class IndexGutenbergBooksProperties < ActiveRecord::Migration
  def change
    add_hstore_index :gutenberg_books, :links
  end
end
