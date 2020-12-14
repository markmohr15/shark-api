class AddBovadaNameToTeam < ActiveRecord::Migration[6.0]
def up
    add_column :teams, :bovada_name, :string

    Team.all.each do |t|
      t.update bovada_name: t.name
    end
  end

  def down
    remove_column :teams, :bovada_name
  end
end
