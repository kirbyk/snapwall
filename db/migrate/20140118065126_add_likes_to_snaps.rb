class AddLikesToSnaps < ActiveRecord::Migration
  def change
    add_column :snaps, :likes, :integer, default: 0
  end
end
