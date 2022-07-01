# == Schema Information
#
# Table name: weathers
#
#  id          :bigint           not null, primary key
#  day         :integer
#  dt          :datetime
#  eve         :integer
#  high        :integer
#  low         :integer
#  morn        :integer
#  night       :integer
#  report_type :integer
#  temp        :integer
#  weather     :string
#  wind_deg    :integer
#  wind_speed  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :bigint           not null
#
# Indexes
#
#  index_weathers_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
class Weather < ApplicationRecord
  belongs_to :game

  enum report_type: { daily: 0, hourly: 1, current: 2 }

  validates_presence_of :dt

  def display_hourly_time
    dt.strftime('%-l %p')
  end
end
