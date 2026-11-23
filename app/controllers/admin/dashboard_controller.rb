module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        cars: Car.count,
        available: Car.available.count,
        orders: Order.count,
        pending_drives: TestDrive.pending.count,
        new_messages: FeedbackMessage.where(handled: false).count,
        users: User.count
      }
      @recent_orders = Order.includes(:user, :branch).order(created_at: :desc).limit(5)
    end
  end
end
