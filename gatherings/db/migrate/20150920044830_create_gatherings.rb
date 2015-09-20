class CreateGatherings < ActiveRecord::Migration
  def change
    create_table :gatherings do |t|
      t.string :name
      t.string :path
      t.timestamp :active_on
      t.timestamp :inactive_on

      t.timestamps null: false
    end
  end
end
