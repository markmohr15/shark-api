# == Schema Information
#
# Table name: divisions
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  active       :boolean          default(TRUE)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  league_id    :bigint           not null
#
# Indexes
#
#  index_divisions_on_league_id  (league_id)
#
# Foreign Keys
#
#  fk_rails_...  (league_id => leagues.id)
#

class Division < ApplicationRecord
  belongs_to :league

  has_many :subdivisions, dependent: :destroy
  has_many :teams
 
  delegate :sport, to: :league

  validates_presence_of :name

  before_create do
    self.abbreviation ||= self.name
  end
end
