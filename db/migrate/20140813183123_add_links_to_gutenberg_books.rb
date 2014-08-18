class AddLinksToGutenbergBooks < ActiveRecord::Migration
  def up
    remove_column :gutenberg_books, :links
    add_column :gutenberg_books, :links, :hstore
  end

  def down
    remove_column :gutenberg_books, :links
    add_column :gutenberg_books, :links, :text
  end
end
