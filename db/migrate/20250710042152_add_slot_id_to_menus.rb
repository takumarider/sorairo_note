class AddSlotIdToMenus < ActiveRecord::Migration[8.0]
  def change
    add_reference :menus, :slot, null: true, foreign_key: true
  end
end
