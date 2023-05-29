class GuitarsController < ApplicationController
  before_action :set_guitar, only: %i[destroy show uptdate]
  skip_before_action :authenticate_user!, only: :index

  def index
    @guitars = Guitar.all
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
