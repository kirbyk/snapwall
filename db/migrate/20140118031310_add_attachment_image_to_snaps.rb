class AddAttachmentImageToSnaps < ActiveRecord::Migration
  def self.up
    change_table :snaps do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :snaps, :image
  end
end
