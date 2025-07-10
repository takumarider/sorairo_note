class RemoveSlotIdFromMenus < ActiveRecord::Migration[8.0]
  def change
    remove_column :menus, :slot_id, :bigint
  end
end
