class ChangeTitlesDescriptionsInOclcBooks < ActiveRecord::Migration
  def up
    remove_column :oclc_books, :titles
    remove_column :oclc_books, :descriptions

    add_column :oclc_books, :titles, :text, :array => true, :default => '{}'
    add_column :oclc_books, :descriptions, :text, :array => true, :default => '{}'
  end

  def down
    remove_column :oclc_books, :titles
    remove_column :oclc_books, :descriptions

    add_column :oclc_books, :titles, :text, :array => true, :default => '{}'
    add_column :oclc_books, :descriptions, :text, :array => true, :default => '{}'
  end
end
