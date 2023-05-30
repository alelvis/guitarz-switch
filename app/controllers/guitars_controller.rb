class GuitarsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @guitars = Guitar.all
  end

  def show
    @guitar = Guitar.find(params[:id])
    @guitars = Guitar.new
  end
end
