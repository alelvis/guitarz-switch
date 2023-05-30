class Guitar < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_one_attached :photo

  validates :name, :brand, :model, :right_handed, :price_per_day, :rental_city, presence: true
  validates :price_per_day, :year, numericality: { only_integer: true }
  validates :year, numericality: { greater_than_or_equal_to: 1930, less_than_or_equal_to: Date.current.year }
  validates :right_handed, inclusion: [true, false]
end
