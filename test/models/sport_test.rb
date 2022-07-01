# == Schema Information
#
# Table name: sports
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  active       :boolean          default(TRUE)
#  baseball     :boolean          default(FALSE)
#  name         :string
#  weather      :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class SportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
