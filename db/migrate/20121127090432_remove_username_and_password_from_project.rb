class RemoveUsernameAndPasswordFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :username
    remove_column :projects, :encrypted_password
  end

  def down
    add_column :projects, :username, :string
    add_column :projects, :encrypted_password, :string
  end
end
