# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_user!   # Deviseでログイン済みか？
  before_action :authenticate_admin!  # adminユーザーか？

  layout "admin"  # 管理者用のレイアウトを適用

  private

  def authenticate_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者専用ページです。"
    end
  end
end
