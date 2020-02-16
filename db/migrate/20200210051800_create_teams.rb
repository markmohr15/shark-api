class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :nickname
      t.boolean :active, default: true
      t.references :sport, null: false, foreign_key: true
      t.references :league, foreign_key: true
      t.references :division, foreign_key: true
      t.references :subdivision, foreign_key: true
      t.string :short_display_name
      t.integer :sportsdata_id

      t.timestamps
    end
  end
end
