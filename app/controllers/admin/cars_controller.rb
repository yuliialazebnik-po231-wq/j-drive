module Admin
  class CarsController < BaseController
    before_action :set_car, only: %i[edit update destroy]
    before_action :load_brands, only: %i[new create edit update]

    def index
      @cars = Car.includes(:brand).order(created_at: :desc)
    end

    def new
      @car = Car.new
    end

    def create
      @car = Car.new(car_params)

      if @car.save
        redirect_to admin_cars_path, notice: "Авто додано."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @car.update(car_params)
        redirect_to admin_cars_path, notice: "Зміни збережено."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @car.destroy
        redirect_to admin_cars_path, notice: "Авто видалено.", status: :see_other
      else
        redirect_to admin_cars_path, alert: "Не можна видалити: це авто є в замовленнях.", status: :see_other
      end
    end

    private

    def set_car
      @car = Car.find(params[:id])
    end

    def load_brands
      @brands = Brand.order(:name)
    end

    def car_params
      params.require(:car).permit(:brand_id, :name, :year, :price, :body_type, :engine, :horsepower,
                                  :transmission, :drive, :color, :status, :description)
    end
  end
end
