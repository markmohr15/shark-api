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

require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
