Rails.application.routes.draw do
  devise_for :users

  get "users/mypage", to: "users#mypage", as: :mypage

  namespace :users do
    resources :reservations, only: [ :index, :new, :create, :edit, :update ]
    get "calendar", to: "calendar#index"
    get "calendar/slots/:date", to: "calendar#slots_for_date"
    get "calendar/menus", to: "calendar#menus"
    post "calendar/reservations", to: "calendar#create_reservation"
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :reservations
    resources :slots do
      collection do
        get :calendar
      end
    end
    resources :menus
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
