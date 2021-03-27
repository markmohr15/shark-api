class AddAbbreviationToSportsbook < ActiveRecord::Migration[6.0]
  def change
    add_column :sportsbooks, :abbreviation, :string
  end
end
