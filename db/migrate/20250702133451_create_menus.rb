class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.string  :name,        null: false
      t.text    :description
      t.integer :price,       null: false
      t.integer :duration,    null: false
      t.date    :start_date
      t.date    :end_date
      t.boolean :available,   null: false, default: true

      t.references :slot,     null: false, foreign_key: true

      t.timestamps
    end
  end
end
