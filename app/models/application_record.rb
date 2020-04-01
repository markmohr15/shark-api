class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :active, -> { where active: true }
end
