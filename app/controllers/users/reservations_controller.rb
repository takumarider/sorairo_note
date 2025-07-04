# app/controllers/users/reservations_controller.rb
class Users::ReservationsController < ApplicationController
  before_action :set_reservation, only: [ :edit, :update ]

  def index
    @reservations = current_user.reservations.includes(:menu, :slot).order(created_at: :desc)
  end
  def new
    @reservation = current_user.reservations.new
    @menus = Menu.available
    @slots = Slot.all
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    if @reservation.save
      redirect_to mypage_path, notice: "予約が完了しました"
    else
      @menus = Menu.available
      @slots = Slot.all
      render :new
    end
  end

  def edit
    @menus = Menu.available
    @slots = Slot.all
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to mypage_path, notice: "予約を更新しました"
    else
      @menus = Menu.available
      @slots = Slot.all
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
