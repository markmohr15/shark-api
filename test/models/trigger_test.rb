# == Schema Information
#
# Table name: triggers
#
#  id         :bigint           not null, primary key
#  gametime   :datetime
#  notified   :boolean          default(FALSE)
#  operator   :integer
#  status     :integer          default("open")
#  target     :float
#  wager_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  team_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_triggers_on_game_id  (game_id)
#  index_triggers_on_team_id  (team_id)
#  index_triggers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
