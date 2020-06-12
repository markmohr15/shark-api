class AddGametimeToTriggers < ActiveRecord::Migration[6.0]
  def change
    add_column :triggers, :gametime, :datetime
  end
end
