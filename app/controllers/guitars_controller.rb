class GuitarsController < ApplicationController
  before_action :set_guitar, only: %i[destroy show edit update]
  skip_before_action :authenticate_user!, only: :index

  after_action :skip_authorization, only: %i[my_guitars]
  after_action :verify_policy_scoped, only: %i[my_guitars], unless: :skip_pundit?

  def index
    rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today).map(&:guitar)
    rented_for_a_while = rented_guitars.reject { |guitar| guitar.next_availability <= Date.today + 15 }
    if params[:query].present?
      @guitars = @guitars.search_brand_and_city(params[:query])
    else
      @guitars = policy_scope(Guitar)
    end
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @guitars = @guitars.select do |guitar|
        (start_date..end_date).all? do |date|
          current_rental = Order.where(guitar:).where('start_date <= ? AND end_date >= ?', date, date)
          current_rental.empty?
        end
      end
    else
      @guitars = @guitars.where.not(id: rented_for_a_while.pluck(:id)).where.not(user: current_user)
    end
    @guitars.order!(id: :desc)
    @guitars
  end

  def search
    @models = Model.search_by_city(params[:city])
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
    if @guitar.can_be_deleted?
      @guitar.destroy
      redirect_to my_guitars_path, notice: "Guitar was successfully destroyed."
    else
      redirect_to guitars_path, notice: "Cannot delete rented guitar."
    end
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
    params.require(:guitar).permit(:name, :brand, :model, :description, :material, :pickup, :right_handed, :year, :country, :price_per_day, :rental_city, photos: [])
  end
end
