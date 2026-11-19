class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car

  def create
    review = @car.reviews.build(review_params.merge(user: current_user))

    if review.save
      redirect_to car_path(@car, anchor: "reviews"), notice: "Дякуємо за відгук!"
    else
      redirect_to car_path(@car, anchor: "reviews"), alert: review.errors.map(&:message).to_sentence
    end
  end

  def destroy
    review = @car.reviews.find(params[:id])

    if review.user_id == current_user.id || current_user.admin?
      review.destroy
      redirect_to car_path(@car, anchor: "reviews"), notice: "Відгук видалено.", status: :see_other
    else
      redirect_to car_path(@car), alert: "У вас немає доступу до цієї дії.", status: :see_other
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end