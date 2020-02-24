class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.references :sport, null: false, foreign_key: true
      t.string :name
      t.boolean :active, default: false
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
