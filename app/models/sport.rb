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
end
