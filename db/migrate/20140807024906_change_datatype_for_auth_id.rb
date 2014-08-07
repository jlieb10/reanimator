class ChangeDatatypeForAuthId < ActiveRecord::Migration
  def up
    change_column :users, :auth_id, :string
  end

  def down
    change_column :users, :auth_id, :integer
  end
end
