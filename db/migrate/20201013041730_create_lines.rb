class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.references :game
      t.references :sportsbook
      t.integer :home_rl
      t.integer :home_ml
      t.float :spread
      t.integer :visitor_rl
      t.integer :visitor_ml
      t.float :total

      t.timestamps
    end
  end
end
