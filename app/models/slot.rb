class Slot < ApplicationRecord
  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :no_overlap

  has_many :reservations, dependent: :destroy
  has_many :menus, dependent: :nullify

  # 予約可能かどうかを判定
  def available?
    available && reservations.empty?
  end

  # 予約済みかどうかを判定
  def booked?
    reservations.exists?
  end

  private

  # 終了時間は開始時間より後であることを保証
  def end_time_after_start_time
    return unless start_time.present? && end_time.present?

    if end_time <= start_time
      errors.add(:end_time, "は開始時刻より後にしてください")
    end
  end

  # 他の時間枠と重複していないかチェック
  def no_overlap
    return unless start_time.present? && end_time.present?

    overlapping_slots = Slot.where.not(id: id)
                            .where("start_time < ? AND end_time > ?", end_time, start_time)
    if overlapping_slots.exists?
      errors.add(:base, "この時間帯は他の時間枠と重複しています")
    end
  end
end
