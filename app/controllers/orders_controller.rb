class OrdersController < ApplicationController
  after_action :skip_authorization, only: %i[my_purchases my_sales]
  after_action :verify_policy_scoped, only: %i[my_purchases my_sales], unless: :skip_pundit?

  def my_purchases
    @orders = Order.where(id: policy_scope(Order).map(&:id)).where.not(user: current_user)
    @orders.order!(start_date: :desc)
  end

  def my_sales
    @orders = Order.where(id: policy_scope(Order).map(&:id)).where(user: current_user)
    @orders.order!(start_date: :desc)
  end
end
