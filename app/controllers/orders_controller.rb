class OrdersController < ApplicationController
  before_action :set_order, only: %i[show destroy]
  after_action :skip_authorization, only: %i[my_purchases my_sales]
  after_action :verify_policy_scoped, only: %i[my_purchases my_sales], unless: :skip_pundit?

  def my_purchases
    @orders = Order.where(id: policy_scope(Order).map(&:id)).where(user: current_user)
    @orders.order!(start_date: :desc)
  end

  def my_sales
    @orders = Order.where(id: policy_scope(Order).map(&:id)).where.not(user: current_user)
    @orders.order!(start_date: :desc)
  end

  def show
    authorize @order
  end

  def destroy
    authorize @order
    if @order.status == "Upcoming"
      @order.destroy
      @order.user == current_user ? (redirect_to my_purchases_path, notice: "Order was successfully canceled") : (redirect_to my_sales_path, notice: "Order was successfully canceled")
    elsif @order.status == "Active"
      redirect_back fallback_location: root_path, alert:  "Active order cannot be canceled"
    else
      redirect_back fallback_location: root_path, alert:  "Concluded order cannot be canceled"
    end
  end

  def create
    @order = Order.new(order_params)
    authorize @order
    @guitar = Guitar.find(params[:guitar_id])
    @order.guitar = @guitar
    @order.user = current_user
    @order.price = @guitar.price_per_day * (@order.end_date - @order.start_date + 1).to_i
    if @order.save
      redirect_to @order
    else
      render "guitars/show", status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:start_date, :end_date)
  end
end
