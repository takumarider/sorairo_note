cclass CreateSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :slots do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :available, default: true, null: false

      t.timestamps
    end
  end
end
