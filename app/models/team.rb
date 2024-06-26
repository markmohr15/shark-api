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

class Team < ApplicationRecord
  belongs_to :sport
  belongs_to :league, optional: true
  belongs_to :division, optional: true
  belongs_to :subdivision, optional: true
  belongs_to :stadium, optional: true

  has_many :games_as_visitor, foreign_key: "visitor_id", class_name: "Game"
  has_many :games_as_home, foreign_key: "home_id", class_name: "Game"
  has_many :triggers
  has_many :tags, dependent: :destroy

  scope :mlb, -> {joins(:sport).where('sports.abbreviation = ?', "MLB")}
  scope :cfb, -> {joins(:sport).where('sports.abbreviation = ?', "CFB")}
  scope :nba, -> {joins(:sport).where('sports.abbreviation = ?', "NBA")}
  scope :cbb, -> {joins(:sport).where('sports.abbreviation = ?', "CBB")}
  scope :nfl, -> {joins(:sport).where('sports.abbreviation = ?', "NFL")}
  scope :nhl, -> {joins(:sport).where('sports.abbreviation = ?', "NHL")}
  scope :kbo, -> {joins(:sport).where('sports.abbreviation = ?', "KBO")}
  scope :npb, -> {joins(:sport).where('sports.abbreviation = ?', "NPB")}
  
  def games
    games_as_visitor.or(games_as_home)
  end

  validates_presence_of :name

  before_create do
    self.short_display_name ||= self.name.upcase[0..4]
    self.nickname ||= ""
  end

  after_create do
    self.tags.create(name: self.name)
    self.tags.create(name: [self.name, self.nickname].join(" ")) if self.nickname.present?
  end

end
