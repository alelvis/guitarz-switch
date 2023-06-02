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
    against: [ :brand, :name, :model ],
    using: {
      tsearch: { prefix: true }
    }

  pg_search_scope :search_by_city, against: :rental_city

  def available?
    current_rental = Order.where(guitar: self).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    current_rental.empty?
  end

  def unavailable_dates
    orders.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end

  def can_be_deleted?
    if orders.upcoming_or_current.exists?
      return false
    else
      return true
    end
  end
end
