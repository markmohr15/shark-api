# == Schema Information
#
# Table name: leagues
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  active       :boolean          default(TRUE)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sport_id     :bigint           not null
#
# Indexes
#
#  index_leagues_on_sport_id  (sport_id)
#
# Foreign Keys
#
#  fk_rails_...  (sport_id => sports.id)
#

require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
