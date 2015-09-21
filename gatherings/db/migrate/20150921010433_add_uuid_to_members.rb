class AddUuidToMembers < ActiveRecord::Migration
  def change
    add_column :members, :uuid, :string
    add_index :members, :uuid
  end
end
