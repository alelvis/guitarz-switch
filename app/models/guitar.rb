class Guitar < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :name, :brand, :model, :right_handed, :price_per_day, presence: true
  validates :price_per_day, :year, numericality: { only_integer: true }
  validates :right_handed, inclusion: [true, false]
end
