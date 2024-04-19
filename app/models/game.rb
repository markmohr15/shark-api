# == Schema Information
#
# Table name: games
#
#  id                 :bigint           not null, primary key
#  channel            :string
#  conference_game    :boolean          default(FALSE)
#  gametime           :datetime
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
#  index_games_on_gametime   (gametime)
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

  has_many :triggers, dependent: :destroy
  has_many :lines, dependent: :destroy
  has_many :scheduled_last_lines, -> { scheduled_last_lines }, class_name: "Line"
  has_many :completed_last_lines, -> { completed_last_lines }, class_name: "Line"
  has_many :weathers, dependent: :destroy
  
  enum status: { Scheduled: 0, InProgress: 1, Final: 2, Postponed: 3, Canceled: 4, "F/OT" => 5, "F/SO" => 6, Cancelled: 7 }

  before_validation :set_defaults
  after_save :set_in_progress

  def set_defaults
    self.visitor_rot = home_rot.to_i - 1 if home_rot.present?
    self.season ||= sport&.seasons&.active&.last
    self.status ||= "Scheduled"
    if self.stadium.blank? || self.stadium&.name == "Unknown"
      self.stadium = (home&.stadium || Stadium.find_by_name('Unknown'))
    end
  end

  def set_in_progress
    return unless previous_changes.keys.include? "gametime"
    r = Sidekiq::ScheduledSet.new
    r.select do |scheduled|
      scheduled.klass == 'FetchGameTimeWeatherWorker' &&
      scheduled.args[0] == self.id
    end.map(&:delete)
    r.select do |scheduled|
      scheduled.klass == 'SetInProgressWorker' &&
      scheduled.args[0] == self.id
    end.map(&:delete)
    FetchGameTimeWeatherWorker.perform_at(self.gametime, self.id)
    SetInProgressWorker.perform_at(self.gametime + 1.minutes, self.id)
    DeleteWeathersWorker.perform_at(self.gametime + 12.hours, self.id)
    DeleteLinesWorker.perform_at(self.gametime + 30.hours, self.id)
  end

  def last_lines 
    self.Scheduled? ? scheduled_last_lines : completed_last_lines
  end

  def display_time
    gametime.strftime('%R')
  end

  def display_date
    gametime.strftime('%m/%d')
  end

  def datetime_to_s
    return "" if gametime.blank?
    gametime.strftime('%B %d, %Y, %-l:%M %p (Eastern)')
  end

  def user_home_spread user
    Line.from(Line.user_last_lines(user, self)).pluck(:home_spread).reject{|x| x.blank?}.max
  end

  def display_home_spread user
    LineHelper.display_spread user_home_spread(user)
  end

  def user_visitor_spread user
    Line.from(Line.user_last_lines(user, self)).pluck(:visitor_spread).reject{|x| x.blank?}.max
  end

  def display_visitor_spread user
    LineHelper.display_spread user_visitor_spread(user)
  end

  def user_home_ml user
    Line.from(Line.user_last_lines(user, self)).pluck(:home_ml).reject{|x| x.blank?}.max
  end

  def display_home_ml user
    LineHelper.display_ml user_home_ml(user)
  end

  def user_visitor_ml user
    Line.from(Line.user_last_lines(user, self)).pluck(:visitor_ml).reject{|x| x.blank?}.max
  end

  def display_visitor_ml user
    LineHelper.display_ml user_visitor_ml(user)
  end

  def user_home_rl user
    spread = user_home_spread user
    return nil if spread.nil?
    Line.user_last_lines(user, self).select {|x| x.home_spread == spread}
                                    .pluck(:home_rl)
                                    .reject{|x| x.blank?}.max
  end

  def display_home_rl user
    LineHelper.display_ml user_home_rl(user)
  end

  def user_visitor_rl user
    spread = user_visitor_spread user
    return nil if spread.nil?
    Line.user_last_lines(user, self).select {|x| x.visitor_spread == spread}
                                    .pluck(:visitor_rl)
                                    .reject{|x| x.blank?}.max
  end

  def display_visitor_rl user
    LineHelper.display_ml user_visitor_rl(user)
  end

  def user_over user
    Line.from(Line.user_last_lines(user, self)).pluck(:total).reject{|x| x.blank?}.min
  end

  def display_over user
    LineHelper.display_total "over", user_over(user)
  end

  def user_over_odds user
    over = user_over user
    return nil if over.nil?
    Line.user_last_lines(user, self).select {|x| x.total == over}
                                    .pluck(:over_odds)
                                    .reject{|x| x.blank?}.max
  end

  def display_over_odds user
    LineHelper.display_ml user_over_odds(user)
  end

  def user_under user
    Line.from(Line.user_last_lines(user, self)).pluck(:total).reject{|x| x.blank?}.max
  end

  def display_under user
    LineHelper.display_total "under", user_under(user)
  end

  def user_under_odds user
    under = user_under user
    return nil if under.nil?
    Line.user_last_lines(user, self).select {|x| x.total == under}
                                    .pluck(:under_odds)
                                    .reject{|x| x.blank?}.max
  end

  def display_under_odds user
    LineHelper.display_ml user_under_odds(user)
  end

  def current_weather
    if self.weathers.current.any?
      self.weathers.current.order('dt desc').first
    else
      nil
    end
  end

  def weather_reports
    if self.weathers.hourly.any?
      self.weathers.hourly
                   .where('dt >= ? and dt <= ?', gametime - 30.minutes, gametime + 210.minutes)
                   .order(:dt)
    elsif self.weathers.daily.any?
      self.weathers.daily.where('dt >= ? and dt <= ?', gametime.beginning_of_day, gametime.end_of_day)
    else
      []
    end
  end

end


