class MakeLinksHstoreHash < ActiveRecord::Migration
  def up
    remove_column :gutenberg_books, :links
    add_column :gutenberg_books, :links, :hstore
    add_index :gutenberg_books, [:links], name: "gutenberg_books_links", using: :gin
  end

  def down
    remove_index :gutenberg_books, name: "gutenberg_books_links"
    remove_column :gutenberg_books, :links
    add_column :gutenberg_books, :links, :text
  end
end
