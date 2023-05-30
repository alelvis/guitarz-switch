class Order < ApplicationRecord
  belongs_to :user
  belongs_to :guitar

  validates :price, :start_date, :end_date, presence: true
  validates :price, numericality: { only_integer: true }
  validates :start_date, comparison: { greater_than: :end_date }
  validates :start_date, :end_date
end

t.references :user, null: false, foreign_key: true
t.references :guitar, null: false, foreign_key: true
t.integer :price
t.date :start_date
t.date :end_date
