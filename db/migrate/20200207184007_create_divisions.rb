class CreateDivisions < ActiveRecord::Migration[6.0]
  def change
    create_table :divisions do |t|
      t.string :name
      t.boolean :active, default: true
      t.references :league, null: false, foreign_key: true
      t.string :abbreviation

      t.timestamps
    end
  end
end
