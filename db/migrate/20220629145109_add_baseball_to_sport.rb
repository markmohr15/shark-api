class AddBaseballToSport < ActiveRecord::Migration[6.1]
  def change
    add_column :sports, :baseball, :boolean, default: false
  end
end
