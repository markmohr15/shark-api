class CreateSportsbooks < ActiveRecord::Migration[6.0]
  def change
    create_table :sportsbooks do |t|
      t.string :name

      t.timestamps
    end
  end
end
