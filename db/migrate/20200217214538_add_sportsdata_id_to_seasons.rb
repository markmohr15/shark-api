class AddSportsdataIdToSeasons < ActiveRecord::Migration[6.0]
  def change
    add_column :seasons, :sportsdata_id, :integer
  end
end
