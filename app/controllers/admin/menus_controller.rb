class Admin::MenusController < Admin::BaseController
  before_action :set_menu, only: %i[edit update destroy]

  def index
    @menus = Menu.includes(:slot).order(:start_date)
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      redirect_to admin_menus_path, notice: "メニューを作成しました"
    else
      render :new
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
    @menu.destroy
    redirect_to admin_menus_path, notice: "メニューを削除しました"
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :price, :duration, :start_date, :end_date, :available, :slot_id)
  end
end
