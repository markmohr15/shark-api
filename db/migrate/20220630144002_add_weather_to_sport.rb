class AddWeatherToSport < ActiveRecord::Migration[6.1]
  def change
    add_column :sports, :weather, :boolean, default: false
  end
end
