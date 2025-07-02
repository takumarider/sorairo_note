Rails.application.routes.draw do
  # 認証系（Devise）
  devise_for :users

  # ユーザー機能
  get "users/mypage", to: "users#mypage", as: :mypage

  # 管理者機能（admin名前空間）
  namespace :admin do
    get "dashboard/index"
    root to: "dashboard#index"
    resources :reservations
    resources :slots
    resources :menus
  end

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページ
  root "home#index"
end
