# == Schema Information
#
# Table name: counters
#
#  id         :bigint           not null, primary key
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Counter < ApplicationRecord

	def increment
		update(count: count + 1)
	end
end
