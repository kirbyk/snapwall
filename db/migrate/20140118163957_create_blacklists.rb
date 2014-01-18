class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.string :username

      t.timestamps
    end
  end
end
