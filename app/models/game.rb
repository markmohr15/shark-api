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
  has_many :lines
  
  enum status: { Scheduled: 0, InProgress: 1, Final: 2, Postponed: 3, Canceled: 4, "F/OT" => 5, "F/SO" => 6, Cancelled: 7 }

  scope :active_lines, -> {where.not(home_ml: nil, home_rl: nil, visitor_ml: nil, visitor_rl: nil, total: nil, spread: nil) }
  
  after_initialize do
    if new_record?
      self.sport ||= season&.sport
    end
  end

  before_save :set_visitor_rot
  after_save :set_in_progress

  def set_visitor_rot
    self.visitor_rot = home_rot.to_i - 1 if home_rot.present?
  end

  def set_in_progress
    return unless previous_changes.keys.include? "gametime"
    r = Sidekiq::ScheduledSet.new
    r.select do |scheduled|
      scheduled.klass == 'SetInProgressWorker' &&
      scheduled.args[0] == self.id
    end.map(&:delete)
    SetInProgressWorker.perform_at(self.gametime, self.id)
  end

  def display_time
    gametime.strftime('%R')
  end

  def display_date
    gametime.strftime('%m/%d')
  end

  def user_last_lines user
    user.sportsbooks.map {|s| s.lines.where(game: self).last}
                    .reject {|l| l.nil?}
  end

  def user_home_spread user
    user_last_lines(user).pluck(:home_spread).reject{|x| x.blank?}.max
  end

  def display_home_spread user
    Game.display_spread user_home_spread(user)
  end

  def user_visitor_spread user
    user_last_lines(user).pluck(:visitor_spread).reject{|x| x.blank?}.max
  end

  def display_visitor_spread user
    Game.display_spread user_visitor_spread(user)
  end

  def user_home_ml user
    user_last_lines(user).pluck(:home_ml).reject{|x| x.blank?}.max
  end

  def display_home_ml user
    Game.display_ml user_home_ml(user)
  end

  def user_visitor_ml user
    user_last_lines(user).pluck(:visitor_ml).reject{|x| x.blank?}.max
  end

  def display_visitor_ml user
    Game.display_ml user_visitor_ml(user)
  end

  def user_home_rl user
    spread = user_home_spread user
    return nil if spread.nil?
    rls = user_last_lines(user).select {|x| x.home_spread == spread}
                               .pluck(:home_rl).max
  end

  def display_home_rl user
    Game.display_ml user_home_rl(user)
  end

  def user_visitor_rl user
    spread = user_visitor_spread user
    return nil if spread.nil?
    rls = user_last_lines(user).select {|x| x.visitor_spread == spread}
                               .pluck(:visitor_rl).max
  end

  def display_visitor_rl user
    Game.display_ml user_visitor_rl(user)
  end

  def user_over user
    user_last_lines(user).pluck(:total).reject{|x| x.blank?}.min
  end

  def display_over user
    uo = user_over user
    uo.present? ? "Ov #{uo}" : ""
  end

  def user_under user
    user_last_lines(user).pluck(:total).reject{|x| x.blank?}.max
  end

  def display_under user
    uu = user_under user
    uu.present? ? "Un #{uu}" : ""
  end

  def self.display_spread spr
    case spr
    when blank?
      "" 
    when 0
      "PK"
    when 0..1000
      "+#{spr}"
    else
      spr.to_s
    end
  end

  def self.display_ml ml
    case ml
    when blank?
      ""
    when 100..100000
      "+#{ml}"
    else
      ml.to_s
    end
  end

end


