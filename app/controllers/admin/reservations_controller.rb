# app/controllers/admin/reservations_controller.rb
class Admin::ReservationsController < Admin::BaseController
  def index
    @reservations = Reservation.all
  end

  # 例：編集や削除などのアクションも必要に応じて追加
end
