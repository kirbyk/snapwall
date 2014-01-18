class CreateSnaps < ActiveRecord::Migration
  def change
    create_table :snaps do |t|
      t.string :username
      t.integer :duration
      t.string :snap_id

      t.timestamps
    end
  end
end
