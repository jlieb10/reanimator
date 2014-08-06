class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image_url

      # give to us as uid by google
      t.integer :google_id, :index => true

      t.timestamps
    end
  end
end
