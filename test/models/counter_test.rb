# == Schema Information
#
# Table name: counters
#
#  id         :bigint           not null, primary key
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CounterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
