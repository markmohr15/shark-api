class CreateSports < ActiveRecord::Migration[6.0]
  def change
    create_table :sports do |t|
      t.string :name
      t.string :abbreviation
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
