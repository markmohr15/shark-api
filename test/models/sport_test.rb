# == Schema Information
#
# Table name: sports
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class SportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
