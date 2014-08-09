class CreateOclcWorks < ActiveRecord::Migration
  def change
    create_table :oclc_works, :id => false, :primary_key => :nid do |t|
      # ie owi-1380224257
      t.string :nid, :index => true
    end
  end
end
