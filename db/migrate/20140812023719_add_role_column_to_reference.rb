class AddRoleColumnToReference < ActiveRecord::Migration
  def change
    add_column :references, :role, :string
  end
end
