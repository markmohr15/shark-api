class AddNotifiedToTrigger < ActiveRecord::Migration[6.0]
  def change
    add_column :triggers, :notified, :boolean, default: false
  end
end
