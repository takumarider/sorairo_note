class ApplicationController < ActionController::Base
  # ログイン後：マイページへ
  def after_sign_in_path_for(resource)
    mypage_path
  end

  # ログアウト後：ログイン画面へ
  def after_sign_out_path_for(resource_or_scope)
    root_path  # ここを変更しました
  end

  # 管理者機能のためのBasic認証
  before_action :basic_auth, if: :admin_namespace?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      user == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def admin_namespace?
    request.fullpath.start_with?("/admin")
  end
end
