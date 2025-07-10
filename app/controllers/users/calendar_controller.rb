class Users::CalendarController < ApplicationController
  before_action :authenticate_user!

  def index
    # カレンダー表示用のデータを取得
    @slots = Slot.where("start_time >= ?", Date.current.beginning_of_day)
                 .order(:start_time)
  end

  def slots_for_date
    date = Date.parse(params[:date])
    slots = Slot.where("DATE(start_time) = ?", date)
                .where(available: true)
                .order(:start_time)

    render json: slots.map { |slot|
      {
        id: slot.id,
        start_time: slot.start_time.strftime("%H:%M"),
        end_time: slot.end_time.strftime("%H:%M"),
        available: slot.available? && !slot.booked?
      }
    }
  end

  def menus
    render json: Menu.available.select(:id, :name, :price, :duration)
  end

  def create_reservation
    slot = Slot.find(params[:slot_id])
    menu = Menu.find(params[:menu_id])

    # 予約可能かチェック
    if slot.reservations.exists?
      render json: { error: "この時間帯は既に予約されています" }, status: :unprocessable_entity
      return
    end

    # 予約を作成
    reservation = current_user.reservations.build(
      slot: slot,
      menu: menu
    )

    if reservation.save
      render json: {
        success: true,
        message: "予約が完了しました",
        reservation_id: reservation.id
      }
    else
      render json: { error: reservation.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
end
