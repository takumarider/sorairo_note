# app/controllers/admin/slots_controller.rb
class Admin::SlotsController < Admin::BaseController
  before_action :set_slot, only: %i[edit update destroy]

  def index
    @slots = Slot.order(:start_time)
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)
    if @slot.save
      redirect_to admin_slots_path, notice: "時間枠を作成しました"
    else
      render :new
    end
  end

  def edit
    @slot = Slot.find(params[:id])
  end

  def update
    if @slot.update(slot_params)
      redirect_to admin_slots_path, notice: "時間枠を更新しました"
    else
      render :edit
    end
  end

    def destroy
      @slot.destroy
      redirect_to admin_slots_path, notice: "時間枠を削除しました"
    end

  private

  def set_slot
   @slot = Slot.find(params[:id])
   end

   def slot_params
   params.require(:slot).permit(:start_time, :end_time, :available)
   end
end
