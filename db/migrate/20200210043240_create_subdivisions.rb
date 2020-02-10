class CreateSubdivisions < ActiveRecord::Migration[6.0]
  def change
    create_table :subdivisions do |t|
      t.string :name
      t.boolean :active, default: true
      t.references :division, null: false, foreign_key: true

      t.timestamps
    end
  end
end
