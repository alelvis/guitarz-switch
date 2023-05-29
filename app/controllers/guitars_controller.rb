class GuitarsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @guitars = Guitar.all
  end
end
