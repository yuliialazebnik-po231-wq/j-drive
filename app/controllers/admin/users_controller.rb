module Admin
  class UsersController < BaseController
    def index
      @users = User.includes(:orders, cart: :cart_items).order(:id)
    end

    def show
      @user = User.find(params[:id])
      @cart_items = @user.cart ? @user.cart.cart_items.includes(car: :brand) : []
      @orders = @user.orders.includes(:branch, :cars).order(created_at: :desc)
      @test_drives = @user.test_drives.includes(car: :brand).order(scheduled_at: :desc)
    end
  end
end