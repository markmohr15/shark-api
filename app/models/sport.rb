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
  has_many :leagues
  has_many :divisions, through: :leagues
  has_many :subdivisions, through: :divsions
  has_many :teams
  has_many :seasons
  has_many :games
  has_many :stadiums

  scope :mlb, -> {find_by_abbreviation "MLB"}
  scope :cfb, -> {find_by_abbreviation "CFB"}
  scope :nba, -> {find_by_abbreviation "NBA"}
  scope :cbb, -> {find_by_abbreviation "CBB"}
  scope :nfl, -> {find_by_abbreviation "NFL"}
  scope :nhl, -> {find_by_abbreviation "NHL"}
end
