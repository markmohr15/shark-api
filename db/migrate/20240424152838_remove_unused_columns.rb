class RemoveUnusedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :teams, :bookmaker_name
    remove_column :teams, :bovada_name
    remove_column :games, :home_ml
    remove_column :games, :home_rl
    remove_column :games, :spread
    remove_column :games, :visitor_ml
    remove_column :games, :visitor_rl
    remove_column :games, :total
  end
end
