# == Schema Information
#
# Table name: teams
#
#  id                 :bigint           not null, primary key
#  active             :boolean          default(TRUE)
#  name               :string
#  nickname           :string
#  short_display_name :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  division_id        :bigint
#  league_id          :bigint
#  sport_id           :bigint           not null
#  sportsdata_id      :integer
#  stadium_id         :bigint
#  subdivision_id     :bigint
#
# Indexes
#
#  index_teams_on_division_id     (division_id)
#  index_teams_on_league_id       (league_id)
#  index_teams_on_sport_id        (sport_id)
#  index_teams_on_stadium_id      (stadium_id)
#  index_teams_on_subdivision_id  (subdivision_id)
#
# Foreign Keys
#
#  fk_rails_...  (division_id => divisions.id)
#  fk_rails_...  (league_id => leagues.id)
#  fk_rails_...  (sport_id => sports.id)
#  fk_rails_...  (subdivision_id => subdivisions.id)
#

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
