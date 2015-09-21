class AddOmniauthToMembers < ActiveRecord::Migration
  def change
    add_column :members, :provider, :string
    add_index :members, :provider
    add_column :members, :uid, :string
    add_index :members, :uid
  end
end
