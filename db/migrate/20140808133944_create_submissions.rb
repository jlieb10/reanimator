class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :question_option, index: true

      t.timestamps
    end
  end
end
