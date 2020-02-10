# == Schema Information
#
# Table name: subdivisions
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  division_id :bigint           not null
#
# Indexes
#
#  index_subdivisions_on_division_id  (division_id)
#
# Foreign Keys
#
#  fk_rails_...  (division_id => divisions.id)
#

class Subdivision < ApplicationRecord
  belongs_to :division
end
