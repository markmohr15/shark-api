class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :sport, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true
      t.integer :visitor_id
      t.integer :home_id
      t.integer :stadium_id
      t.boolean :neutral
      t.integer :visitor_score
      t.integer :home_score
      t.integer :visitor_rot
      t.integer :home_rot
      t.datetime :when
      t.integer :status
      t.integer :sportsdata_game_id
      t.integer :week
      t.boolean :conference_game
      t.float :spread
      t.float :total
      t.integer :visitor_ml
      t.integer :home_ml
      t.integer :visitor_rl
      t.integer :home_rl
      t.integer :period
      t.integer :time_left_min
      t.integer :time_left_sec
      t.string :channel
      

      t.timestamps
    end
  end
end
