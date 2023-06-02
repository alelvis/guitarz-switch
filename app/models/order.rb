class Order < ApplicationRecord
  belongs_to :user
  belongs_to :guitar

  scope :upcoming_or_current, -> {where("start_date <= ? OR end_date >= ?", Date.today, Date.today)}

  validates :price, :start_date, :end_date, presence: true
  validates :price, numericality: { only_integer: true }
  validates :end_date, comparison: { greater_than: :start_date }

  def status
    if end_date <= Date.today
      "Concluded"
    elsif start_date >= Date.today
      "Upcoming"
    else
      "Active"
    end
  end
end
