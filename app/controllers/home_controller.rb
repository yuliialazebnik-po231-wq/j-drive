class HomeController < ApplicationController
  def index
    @featured = Car.available.includes(:brand).order(price: :desc).limit(3)
    @branches = Branch.order(:city)
  end
end
