# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :slot
  belongs_to :menu

  validates :user_id, :slot_id, :menu_id, presence: true
  validate :slot_must_be_available  # ← ここを追加！

  private

  def slot_must_be_available
    # 編集時は自分の予約を除外してチェック
    existing = Reservation.find_by(slot_id: slot_id)
    if existing && existing.id != self.id
      errors.add(:slot_id, "はすでに他のユーザーに予約されています")
    end
  end
end
