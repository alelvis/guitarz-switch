class Guitar < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many_attached :photos
  validates_length_of :photos, maximum: 5

  validates :name, :brand, :model, :right_handed, :price_per_day, :rental_city, presence: true
  validates :price_per_day, :year, numericality: { only_integer: true }
  validates :year, numericality: { greater_than_or_equal_to: 1930, less_than_or_equal_to: Date.current.year }
  validates :right_handed, inclusion: [true, false]

  pg_search_scope :search_brand_and_city,
    against: [ :brand, :rental_city, :model ],
    using: {
      tsearch: { prefix: true }
    }
  def available?
    current_rental = Order.where(guitar: self).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    puts current_rental
    current_rental.empty?
  end

  def unavailable_dates
    orders.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  #test
end
