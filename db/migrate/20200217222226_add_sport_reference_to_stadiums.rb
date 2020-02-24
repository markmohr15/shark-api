class AddSportReferenceToStadiums < ActiveRecord::Migration[6.0]
  def change
    add_reference :stadiums, :sport
    add_column :stadiums, :sportsdata_id, :integer
  end
end
