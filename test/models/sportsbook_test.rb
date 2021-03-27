# == Schema Information
#
# Table name: sportsbooks
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class SportsbookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
