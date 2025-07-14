class Admin::ReservationsController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch("ADMIN_USER", "admin"), password: ENV.fetch("ADMIN_PASS", "password")

  before_action :set_reservation, only: [ :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :create, :edit, :update ]

  def index
    @reservations = Reservation.includes(:user, :slot, :menu).order(created_at: :desc)
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to admin_reservations_path, notice: "予約を登録しました"
    else
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "予約を更新しました"
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    redirect_to admin_reservations_path, notice: "予約を削除しました"
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def load_form_collections
    @users = User.order(:name)
    @menus = Menu.available
    @slots = Slot.order(:start_time)
  end

  def reservation_params
    params.require(:reservation).permit(:user_id, :slot_id, :menu_id)
  end
end
