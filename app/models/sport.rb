# == Schema Information
#
# Table name: sports
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  active       :boolean          default(TRUE)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sport < ApplicationRecord
  has_many :leagues, dependent: :destroy
  has_many :divisions, through: :leagues
  has_many :subdivisions, through: :divsions
  has_many :teams, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :games
  has_many :stadiums, dependent: :destroy
  has_many :tags, through: :teams

  scope :mlb, -> {find_by_abbreviation "MLB"}
  scope :cfb, -> {find_by_abbreviation "CFB"}
  scope :nba, -> {find_by_abbreviation "NBA"}
  scope :cbb, -> {find_by_abbreviation "CBB"}
  scope :nfl, -> {find_by_abbreviation "NFL"}
  scope :nhl, -> {find_by_abbreviation "NHL"}
  scope :kbo, -> {find_by_abbreviation "KBO"}
  scope :npb, -> {find_by_abbreviation "NPB"}
  scope :weather, -> { where 'sports.abbreviation IN (?)', ['MLB', 'CFB', 'NFL']}

  before_destroy :check_games

  validates_presence_of :name

  before_create do
    self.abbreviation ||= self.name
  end

  def check_games
    return false if games.any?
  end

end
