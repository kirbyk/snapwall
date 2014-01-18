class AddSentBestOfToSnaps < ActiveRecord::Migration
  def change
    add_column :snaps, :sent_best_of, :boolean
  end
end
