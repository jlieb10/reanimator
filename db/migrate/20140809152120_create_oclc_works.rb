class CreateOclcWorks < ActiveRecord::Migration
  def change
    create_table :oclc_works do |t|
      # ie owi-1380224257
      t.string :nid, :index => true
    end
  end
end
