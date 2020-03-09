# == Schema Information
#
# Table name: games
#
#  id                 :bigint           not null, primary key
#  channel            :string
#  conference_game    :boolean          default(FALSE)
#  home_ml            :integer
#  home_rl            :integer
#  home_rot           :integer
#  home_score         :integer
#  neutral            :boolean          default(FALSE)
#  period             :integer
#  spread             :float
#  status             :integer
#  time_left_min      :integer
#  time_left_sec      :integer
#  total              :float
#  visitor_ml         :integer
#  visitor_rl         :integer
#  visitor_rot        :integer
#  visitor_score      :integer
#  week               :integer
#  when               :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  home_id            :integer
#  season_id          :bigint           not null
#  sport_id           :bigint           not null
#  sportsdata_game_id :integer
#  stadium_id         :integer
#  visitor_id         :integer
#
# Indexes
#
#  index_games_on_season_id  (season_id)
#  index_games_on_sport_id   (sport_id)
#
# Foreign Keys
#
#  fk_rails_...  (season_id => seasons.id)
#  fk_rails_...  (sport_id => sports.id)
#

class Game < ApplicationRecord
  belongs_to :sport
  belongs_to :season
  belongs_to :stadium
  belongs_to :visitor, class_name: "Team"
  belongs_to :home, class_name: "Team"

  has_many :triggers
  
  enum status: { Scheduled: 0, InProgress: 1, Final: 2, Postponed: 3, Canceled: 4, "F/OT" => 5, "F/SO" => 6, Cancelled: 7 }

  after_initialize do
    if new_record?
      self.sport ||= season&.sport
    end
  end

end
