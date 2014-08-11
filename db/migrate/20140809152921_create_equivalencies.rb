class CreateEquivalencies < ActiveRecord::Migration
  def change
    create_table :equivalencies do |t|
      t.float :confidence
      t.string :oclc_work_nid, :index => true
      t.string :book_nid, :index => true
      t.string :book_type
    end
  end
end
