class AddIndices < ActiveRecord::Migration[6.0]
  def change
    add_index :triggers, :gametime
    add_index :games, :gametime
    add_index :lines, :created_at
  end
end
