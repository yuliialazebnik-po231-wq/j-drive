module Admin
  class ReviewsController < BaseController
    def index
      @reviews = Review.includes(:user, car: :brand).order(created_at: :desc)
    end

    def destroy
      Review.find(params[:id]).destroy
      redirect_to admin_reviews_path, notice: "Відгук видалено.", status: :see_other
    end
  end
end
