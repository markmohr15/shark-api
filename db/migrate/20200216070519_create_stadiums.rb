class CreateStadiums < ActiveRecord::Migration[6.0]
  def change
    create_table :stadiums do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.integer :surface
      t.integer :altitude
      t.float :geo_lat
      t.float :geo_lng
      t.integer :capacity
      t.boolean :active, default: true
      t.string :stadium_type
      t.integer :home_plate_direction
      t.integer :left_field
      t.integer :mid_left_field
      t.integer :left_center_field
      t.integer :mid_left_center_field
      t.integer :center_field
      t.integer :mid_right_center_field
      t.integer :right_center_field
      t.integer :mid_right_field
      t.integer :right_field
      
      t.timestamps
    end
  end
end
