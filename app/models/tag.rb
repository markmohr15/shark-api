# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_tags_on_team_id  (team_id)
#
class Tag < ApplicationRecord
  belongs_to :team
  has_one :sport, through: :team

  validates_uniqueness_of :name, scope: :team
end
