class GuitarsController < ApplicationController
  before_action :set_guitar, only: %i[destroy show edit update]
  skip_before_action :authenticate_user!, only: :index

  def index
    rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @guitars = policy_scope(Guitar).where.not(id: rented_guitars.pluck(:id))
  end

  def my_guitars
    # rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @guitars = Guitar.where(user: current_user)
    authorize @guitars
  end

  def show
    authorize @guitar
  end

  def destroy
    @guitar.destroy
    authorize @guitar
    redirect_to guitars_path, notice: "Guitars was successfully destroyed"
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
    params.require(:guitar).permit(:name, :brand, :model, :description, :material, :pickup, :right_handed, :year, :country, :rental_city, :price_per_day, :photo)
  end
end
