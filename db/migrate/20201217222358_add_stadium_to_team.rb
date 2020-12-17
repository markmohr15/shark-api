class AddStadiumToTeam < ActiveRecord::Migration[6.0]
  def change
    add_reference :teams, :stadium
  end
end
