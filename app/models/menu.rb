class Menu < ApplicationRecord
  belongs_to :slot

  validates :name, :price, :duration, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> {
    where(available: true)
    .where("start_date IS NULL OR start_date <= ?", Date.today)
    .where("end_date IS NULL OR end_date >= ?", Date.today)
  }
end
