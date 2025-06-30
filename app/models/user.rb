# app/models/user.rb

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLE = { user: 0, admin: 1 }

  def admin?
    role == ROLE[:admin]
  end
end
