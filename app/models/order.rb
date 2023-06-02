class Order < ApplicationRecord
  belongs_to :user
  belongs_to :guitar

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
