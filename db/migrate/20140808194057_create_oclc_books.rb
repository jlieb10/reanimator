class CreateOclcBooks < ActiveRecord::Migration
  def change
    create_table :oclc_books, :id => false, :primary_key => :nid do |t|

      # an array of titles
      # ["William Shakespear", "The complete works of William Shakespeare."]
      t.text :titles

      # an array of descriptions
      t.text :descriptions

      # native id
      t.string :nid, :index => true


      t.string :language

    end
  end
end
