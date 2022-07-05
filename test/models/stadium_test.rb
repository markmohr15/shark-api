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
#  roof_status_link       :string
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

require 'test_helper'

class StadiumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
