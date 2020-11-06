# == Schema Information
#
# Table name: lines
#
#  id             :bigint           not null, primary key
#  home_ml        :integer
#  home_rl        :integer
#  home_spread    :float
#  total          :float
#  visitor_ml     :integer
#  visitor_rl     :integer
#  visitor_spread :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :bigint
#  sportsbook_id  :bigint
#
# Indexes
#
#  index_lines_on_game_id        (game_id)
#  index_lines_on_sportsbook_id  (sportsbook_id)
#
require 'test_helper'

class LineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
