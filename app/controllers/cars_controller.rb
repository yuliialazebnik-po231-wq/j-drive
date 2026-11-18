class CarsController < ApplicationController
  def index
    @brands = Brand.order(:name)
    @body_types = Car.distinct.order(:body_type).pluck(:body_type)

    @cars = Car.includes(:brand)
    @cars = @cars.where(brand_id: params[:brand_id]) if params[:brand_id].present?
    @cars = @cars.where(body_type: params[:body_type]) if params[:body_type].present?
    @cars = @cars.where("price <= ?", params[:max_price]) if params[:max_price].present?

    @cars = case params[:sort]
            when "price_asc"  then @cars.order(price: :asc)
            when "price_desc" then @cars.order(price: :desc)
            else @cars.order(created_at: :desc)
            end
  end

  def show
    @car = Car.find(params[:id])
  end
end