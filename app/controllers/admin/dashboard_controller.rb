require "ostruct"

class Admin::DashboardController < Admin::BaseController
  def index
    # 今日〜7日後までの予約一覧（ユーザー・メニュー付き）
    @upcoming_reservations = Reservation
      .includes(:user, :menu, :slot)
      .where(slots: { start_time: Time.current.beginning_of_day..7.days.from_now.end_of_day })
      .references(:slot)
      .order("slots.start_time ASC")

    # Slotごとの予約数サマリー（より安全な方法）
    slots_with_reservations = Slot
      .where(start_time: Time.current.beginning_of_day..7.days.from_now.end_of_day)
      .order(:start_time)

    @slot_summary = slots_with_reservations.map do |slot|
      reservation_count = slot.reservations.count
      OpenStruct.new(
        id: slot.id,
        start_time: slot.start_time,
        end_time: slot.end_time,
        reservation_count: reservation_count
      )
    end
  end
end
