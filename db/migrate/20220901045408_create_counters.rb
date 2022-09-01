class CreateCounters < ActiveRecord::Migration[6.1]
  def up
    create_table :counters do |t|
      t.integer :count

      t.timestamps
    end
    Counter.create count: 0
  end

  def down
    drop_table :counters
  end
end
