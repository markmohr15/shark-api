# == Schema Information
#
# Table name: seasons
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(FALSE)
#  end_date      :date
#  name          :string
#  start_date    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sport_id      :bigint           not null
#  sportsdata_id :integer
#
# Indexes
#
#  index_seasons_on_sport_id  (sport_id)
#
# Foreign Keys
#
#  fk_rails_...  (sport_id => sports.id)
#

class Season < ApplicationRecord
  belongs_to :sport

  has_many :games

  before_destroy :check_games

  validates_presence_of :name, :start_date, :end_date

  def check_games
    return false if games.any?
  end
end
