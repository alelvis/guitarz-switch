class GuitarsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @guitars = Guitar.where.not(id: rented_guitars.pluck(:id))
  end
end
