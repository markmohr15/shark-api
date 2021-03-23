class CreateWeathers < ActiveRecord::Migration[6.0]
  def change
    create_table :weathers do |t|
      t.datetime :dt
      t.integer :temp
      t.integer :high
      t.integer :low
      t.integer :day
      t.integer :morn
      t.integer :eve
      t.integer :night
      t.integer :wind_speed
      t.integer :wind_deg
      t.string :weather
      t.references :game, null: false, foreign_key: true
      t.integer :report_type

      t.timestamps
    end
  end
end
