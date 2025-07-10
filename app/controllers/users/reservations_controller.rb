class Users::ReservationsController < ApplicationController
  before_action :set_reservation, only: [ :edit, :update ]

  def index
    @reservations = current_user.reservations.includes(:menu, :slot).order(created_at: :desc)
  end

  def new
    @reservation = current_user.reservations.new
    @menus = Menu.available

    # 未来日時の予約済みslot_id
    @reserved_slot_ids = Reservation.joins(:slot)
                                   .where("slots.start_time > ?", Time.current)
                                   .pluck(:slot_id)

    # 未来の全Slot
    @all_slots = Slot.where("start_time > ?", Time.current).order(:start_time)

    # 既存のavailable_slotsも残す
    @available_slots = @all_slots.where.not(id: @reserved_slot_ids)
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    if @reservation.save
      redirect_to users_reservations_path, notice: "予約が完了しました"
    else
      @menus = Menu.available

      # create失敗時にも@all_slotsと@reserved_slot_idsをセット
      @reserved_slot_ids = Reservation.joins(:slot)
                                     .where("slots.start_time > ?", Time.current)
                                     .pluck(:slot_id)
      @all_slots = Slot.where("start_time > ?", Time.current).order(:start_time)
      @available_slots = @all_slots.where.not(id: @reserved_slot_ids)
      render :new
    end
  end

  def edit
    @menus = Menu.available

    # 編集画面では自身の予約しているSlotも表示可能にしたい場合
    reserved_slot_ids = Reservation.joins(:slot)
                                   .where("slots.start_time > ?", Time.current)
                                   .where.not(id: @reservation.slot_id)
                                   .pluck(:slot_id)

    @available_slots = Slot.where("start_time > ?", Time.current)
                           .where.not(id: reserved_slot_ids)
                           .or(Slot.where(id: @reservation.slot_id))
                           .order(:start_time)
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to users_reservations_path, notice: "予約を更新しました"
    else
      @menus = Menu.available

      reserved_slot_ids = Reservation.joins(:slot)
                                     .where("slots.start_time > ?", Time.current)
                                     .where.not(id: @reservation.slot_id)
                                     .pluck(:slot_id)

      @available_slots = Slot.where("start_time > ?", Time.current)
                             .where.not(id: reserved_slot_ids)
                             .or(Slot.where(id: @reservation.slot_id))
                             .order(:start_time)
      render :edit
    end
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:slot_id, :menu_id)
  end
end
