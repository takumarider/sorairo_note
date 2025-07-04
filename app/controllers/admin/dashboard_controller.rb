class Admin::DashboardController < Admin::BaseController
  def index
    # 今日〜7日後までの予約一覧（ユーザー・メニュー付き）
    @upcoming_reservations = Reservation
      .includes(:user, :menu, :slot)
      .where(slots: { start_time: Time.current.beginning_of_day..7.days.from_now.end_of_day })
      .references(:slot)
      .order("slots.start_time ASC")

    # Slotごとの予約数サマリー
    @slot_summary = Slot
      .left_joins(:reservations)
      .where(start_time: Time.current.beginning_of_day..7.days.from_now.end_of_day)
      .group("slots.id")
      .select("slots.*, COUNT(reservations.id) AS reservation_count")
      .order("slots.start_time ASC")
  end
end
