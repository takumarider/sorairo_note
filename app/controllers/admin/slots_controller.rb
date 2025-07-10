# app/controllers/admin/slots_controller.rb
class Admin::SlotsController < Admin::BaseController
  before_action :set_slot, only: %i[edit update destroy]

  def index
    @slots = Slot.order(:start_time)

    respond_to do |format|
      format.html
      format.json do
        events = @slots.map do |slot|
          {
            id: slot.id,
            title: "#{slot.start_time.strftime('%H:%M')} - #{slot.end_time.strftime('%H:%M')}",
            start: slot.start_time.iso8601,
            end: slot.end_time.iso8601,
            color: slot.available ? "#28a745" : "#dc3545"
          }
        end
        render json: events
      end
    end
  end

  def calendar
    # カレンダービューを表示
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)
    if @slot.save
      respond_to do |format|
        format.html { redirect_to admin_slots_path, notice: "時間枠を作成しました" }
        format.json { render json: { success: true, message: "時間枠を作成しました" } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { success: false, message: @slot.errors.full_messages.join(", ") } }
      end
    end
  end

  def edit
    @slot = Slot.find(params[:id])
  end

  def update
    if @slot.update(slot_params)
      respond_to do |format|
        format.html { redirect_to admin_slots_path, notice: "時間枠を更新しました" }
        format.json { render json: { success: true, message: "時間枠を更新しました" } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { success: false, message: @slot.errors.full_messages.join(", ") } }
      end
    end
  end

  def destroy
    if @slot.reservations.exists?
      respond_to do |format|
        format.html { redirect_to admin_slots_path, alert: "この枠には予約が存在するため削除できません" }
        format.json { render json: { success: false, message: "この枠には予約が存在するため削除できません" } }
      end
    else
      @slot.destroy
      respond_to do |format|
        format.html { redirect_to admin_slots_path, notice: "時間枠を削除しました" }
        format.json { render json: { success: true, message: "時間枠を削除しました" } }
      end
    end
  end

  private

  def set_slot
   @slot = Slot.find(params[:id])
   end

   def slot_params
   params.require(:slot).permit(:start_time, :end_time, :available)
   end
end
