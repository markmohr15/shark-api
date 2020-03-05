class AddDefaultsToGameBooleans < ActiveRecord::Migration[6.0]
  def change
    change_column_default :games, :conference_game, false
    change_column_default :games, :neutral, false
  end
end
