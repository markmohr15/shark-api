# == Schema Information
#
# Table name: triggers
#
#  id         :bigint           not null, primary key
#  operator   :integer
#  status     :integer          default(0)
#  target     :float
#  wager_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_triggers_on_game_id  (game_id)
#  index_triggers_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (team_id => teams.id)
#

class Trigger < ApplicationRecord
  belongs_to :game
  belongs_to :team

  enum operator: { greater: 0, greater_eq: 1, less: 2, less_eq: 3 }
  enum status: { open: 0, triggered: 1, expired: 2, canceled: 3 }
  enum wager_type: { spread: 0, total: 1, moneyline: 2, runline: 3 }


end
