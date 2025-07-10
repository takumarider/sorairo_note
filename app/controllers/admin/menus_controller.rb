class Admin::MenusController < Admin::BaseController
  before_action :set_menu, only: %i[edit update destroy]

  def index
    @menus = Menu.includes(:slot, :reservations).order(:start_date)
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)

    respond_to do |format|
    if @menu.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("menu-list", partial: "admin/menus/menu_list", locals: { menus: Menu.includes(:slot).order(:start_date) }),
            turbo_stream.update("flash", partial: "shared/flash", locals: { notice: "メニューを作成しました" })
          ]
        end
        format.html { redirect_to admin_menus_path, notice: "メニューを作成しました" }
    else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("menu-form", partial: "admin/menus/form", locals: { menu: @menu })
        end
        format.html { render :new }
    end
    end
  end

  def edit; end

  def update
    if @menu.update(menu_params)
      redirect_to admin_menus_path, notice: "メニューを更新しました"
    else
      render :edit
    end
  end

  def destroy
    # TODO: 将来的に「削除」ではなく「非表示にする」機能を導入する可能性がある
    if @menu.reservations.exists?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash", locals: { alert: "このメニューには予約があります。削除できません。" })
          ]
        end
        format.html { redirect_to admin_menus_path, alert: "このメニューには予約があります。削除できません。" }
      end
      return
    end

    menu_name = @menu.name
    @menu.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("menu-list", partial: "admin/menus/menu_list", locals: { menus: Menu.includes(:slot).order(:start_date) }),
          turbo_stream.update("flash", partial: "shared/flash", locals: { notice: "「#{menu_name}」を削除しました" })
        ]
      end
      format.html { redirect_to admin_menus_path, notice: "メニューを削除しました" }
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :price, :duration, :start_date, :end_date, :available, :slot_id)
  end
end
