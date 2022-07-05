class AddRoofStatusLinkToStadium < ActiveRecord::Migration[6.1]
  def change
    add_column :stadiums, :roof_status_link, :string
  end
end
