class GuitarsController < ApplicationController
  before_action :set_guitar, only: %i[destroy show uptdate]
  skip_before_action :authenticate_user!, only: :index

  def index
    rented_guitars = Order.where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
    @guitars = Guitar.where.not(id: rented_guitars.pluck(:id))
  end

  def destroy
    @guitar.destroy
    redirect_to guitars_path, notice: "Guitars was successfully destroyed"
  end

  private

  def set_guitar
    @guitar = Guitar.find(params[:id])
  end
end
