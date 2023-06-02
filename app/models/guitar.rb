class Guitar < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many_attached :photos
  validates_length_of :photos, minimum: 2, maximum: 5, too_short: "minimum is %{count}", too_long: "maximum is %{count}"

  validates :name, :brand, :model, :price_per_day, :rental_city, :photos, presence: true
  validates :right_handed, presence: { message: "Required" }
  validates :price_per_day, numericality: { only_integer: true }
  validates :year, numericality: { allow_nil: true, only_integer: true, greater_than_or_equal_to: 1930, less_than_or_equal_to: Date.current.year }

  pg_search_scope :search_brand_and_city,
    against: [ :brand, :name, :model, :year, :right_handed ],
    using: {
      tsearch: { prefix: true }
    }

  pg_search_scope :search_by_city, against: :rental_city

  def available?
    current_rental = Order.where(guitar: self).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    current_rental.empty?
  end

  def next_availability
    current_rental = Order.where(guitar: self).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    available = false
    until available
      next_date = current_rental.first.end_date + 1
      p next_date
      current_rental = Order.where(guitar: self).where('start_date = ? OR start_date + 1 = ?', next_date, next_date)
      available = true if current_rental.empty?
    end
    next_date
  end

  def unavailable_dates
    orders.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def can_be_deleted?
    orders.all? { |order| order.status == "Concluded" }
  end
end
