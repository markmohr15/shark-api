class AddTotalJuiceToLine < ActiveRecord::Migration[6.0]
  def change
    add_column :lines, :over_odds, :integer
    add_column :lines, :under_odds, :integer
  end
end
