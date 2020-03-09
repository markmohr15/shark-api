class CreateTriggers < ActiveRecord::Migration[6.0]
  def change
    create_table :triggers do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :operator
      t.float :target
      t.integer :wager_type
      t.integer :status, default: 0
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
