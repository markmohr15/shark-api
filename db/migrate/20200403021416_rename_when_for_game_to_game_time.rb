class RenameWhenForGameToGameTime < ActiveRecord::Migration[6.0]
  def change
    rename_column :games, :when, :gametime
  end
end
