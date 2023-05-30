class OrdersController < ApplicationController
  def my_rentals
    # rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @orders = policy_scope(Order)
    # authorize @orders
  end
end
