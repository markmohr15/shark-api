class MakeTeamOptionalOnTrigger < ActiveRecord::Migration[6.0]
  def change
    change_column_null :triggers, :team_id, true
  end
end
