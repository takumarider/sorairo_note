class ApplicationController < ActionController::Base
  # ログイン後：マイページへ
  def after_sign_in_path_for(resource)
    users_mypage_path
  end

  # ログアウト後：ログイン画面へ
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
