Rails.application.routes.draw do
  # 認証（Devise）
  devise_for :users

  # ユーザー機能
  get "users/mypage", to: "users#mypage", as: :mypage

  namespace :users do
    get "reservations/new"
    get "reservations/create"
    get "reservations/edit"
    get "reservations/update"
    resources :reservations, only: [ :index, :new, :create, :edit, :update ]
  end

  # 管理者機能
  namespace :admin do
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
