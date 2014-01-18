class AddFlagsToSnap < ActiveRecord::Migration
  def change
    add_column :snaps, :flags, :integer, default: 0
  end
end
