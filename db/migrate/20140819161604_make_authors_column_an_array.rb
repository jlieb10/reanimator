class MakeAuthorsColumnAnArray < ActiveRecord::Migration
  def up
    remove_column :gutenberg_books, :authors
    add_column :gutenberg_books, :authors, :text, :array => true, :default => '{}'
  end

  def down
    remove_column :gutenberg_books, :authors
    add_column :gutenberg_books, :authors, :text
  end
end
