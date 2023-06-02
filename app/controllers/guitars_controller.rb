class GuitarsController < ApplicationController
  before_action :set_guitar, only: %i[destroy show edit update]
  skip_before_action :authenticate_user!, only: :index

  after_action :skip_authorization, only: %i[my_guitars]
  after_action :verify_policy_scoped, only: %i[my_guitars], unless: :skip_pundit?

  def index
    rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @guitars = policy_scope(Guitar).where.not(id: rented_guitars.pluck(:id)).where.not(user: current_user)
    @guitars.order!(id: :desc)
    if params[:query].present?
      @guitars = @guitars.search_brand_and_city(params[:query])
    end
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @guitars.select do |guitar|
        range(start_date..end_date).all do |date|
          current_rental = Order.where(guitar: guitar).where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
          current_rental.empty?
        end
      end
    else
      @guitars
    end
  end

  def my_guitars
    @guitars = policy_scope(Guitar).where(user: current_user)
    @guitars.order!(id: :desc)
  end

  def show
    authorize @guitar
    @order = Order.new
    authorize @order
  end

  def destroy
    authorize @guitar
    @guitar.destroy
    redirect_to guitars_path, notice: "Guitar listing was successfully removed"
  end

  def edit
    authorize @guitar
  end

  def update
    authorize @guitar
    if @guitar.update(guitar_params)
      redirect_to guitar_path(@guitar)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @guitar = Guitar.new
    authorize @guitar
  end

  def create
    @guitar = Guitar.new(guitar_params)
    authorize @guitar
    @guitar.user = current_user
    if @guitar.save
      redirect_to @guitar
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_guitar
    @guitar = Guitar.find(params[:id])
  end

  def guitar_params
    params.require(:guitar).permit(:name, :brand, :model, :description, :material, :pickup, :right_handed, :year, :country, :rental_city, :price_per_day, photos: [])
  end
end
