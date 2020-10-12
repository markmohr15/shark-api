class SportsbooksUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :sportsbooks_users, :id => false do |t|
      t.references :sportsbook, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
