class RenameUsersGoogleIdToAuthId < ActiveRecord::Migration
  def up
    rename_column :users, :google_id, :auth_id
  end

  def down
    rename_column :users, :auth_id, :google_id
  end
end
