class AddHomeAndVisitorSpreadToLine < ActiveRecord::Migration[6.0]
  def change
    rename_column :lines, :spread, :home_spread
    add_column :lines, :visitor_spread, :float
  end
end
