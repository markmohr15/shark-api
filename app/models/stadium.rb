# == Schema Information
#
# Table name: stadiums
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  altitude               :integer
#  capacity               :integer
#  center_field           :integer
#  city                   :string
#  country                :string
#  geo_lat                :float
#  geo_lng                :float
#  home_plate_direction   :integer
#  left_center_field      :integer
#  left_field             :integer
#  mid_left_center_field  :integer
#  mid_left_field         :integer
#  mid_right_center_field :integer
#  mid_right_field        :integer
#  name                   :string
#  right_center_field     :integer
#  right_field            :integer
#  stadium_type           :string
#  state                  :string
#  surface                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sport_id               :bigint
#  sportsdata_id          :integer
#
# Indexes
#
#  index_stadiums_on_sport_id  (sport_id)
#

class Stadium < ApplicationRecord
  has_many :games
  has_many :teams

  belongs_to :sport

  enum surface: { Grass: 0, AstroTurf: 1, FieldTurf: 2,
                  Artificial: 3, Hybrid: 4 }

  validates_presence_of :name
end
