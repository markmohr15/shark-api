class AddBookmakerNameToTeam < ActiveRecord::Migration[6.0]
  def up
    add_column :teams, :bookmaker_name, :string

    Team.all.each do |t|
      t.update bookmaker_name: t.name
    end
  end

  def down
    remove_column :teams, :bookmaker_name
  end
end
