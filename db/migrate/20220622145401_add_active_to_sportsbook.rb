class AddActiveToSportsbook < ActiveRecord::Migration[6.1]
  def change
    add_column :sportsbooks, :active, :boolean, default: true
  end
end
