class ChangeTitlesandAuthorsinGutenbergBooks < ActiveRecord::Migration
  def up
    remove_column :gutenberg_books, :titles
    remove_column :gutenberg_books, :authors

    add_column :gutenberg_books, :titles, :text, :array => true, :default => '{}'
    add_column :gutenberg_books, :authors, :text, :array => true, :default => '{}'
  end

  def down
    remove_column :gutenberg_books, :titles
    remove_column :gutenberg_books, :authors

    add_column :gutenberg_books, :titles, :text, :array => true, :default => '{}'
    add_column :gutenberg_books, :authors, :text, :array => true, :default => '{}'
  end
end
