class AddUserIdToTrigger < ActiveRecord::Migration[6.0]
  def change
    add_reference :triggers, :user, foreign_key: true
  end
end
