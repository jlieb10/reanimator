class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|

      # an array of titles
      # ["William Shakespear", "The complete works of William Shakespeare."]
      t.text :titles

      # an array of descriptions
      # []
      t.text :descriptions

      t.string :subtitle

      # oclc or guttenberg
      t.string :type

      # native id
      # OCLC-777327167
      # or Gutenberg-10643
      t.string :nid, :index => true

      # will be a list of authors
      # [ "last name, first name", "last name, first name"]
      t.text :authors

      t.date :date_published

      # will be a hash of links
      # {
      # :home => "http://gutenberg.org/ebooks/10643"
      # :epub => "http://www.gutenberg.org/ebooks/10643.epub.noimages"
      # :html => "http://www.gutenberg.org/files/10643/10643-h/10643-h.htm"
      # :cover => "http://www.gutenberg.org/cache/epub/19002/pg19002.cover.medium.jpg"
      # :internal_images => []
      # }
      #
      t.text :links

      t.string :language
      t.string :publisher
    end
  end
end
