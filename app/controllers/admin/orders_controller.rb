module Admin
  class OrdersController < BaseController
    def index
      @orders = Order.includes(:user, :branch, :cars).order(created_at: :desc)
    end

    def show
      @order = Order.find(params[:id])
    end

    def update
      order = Order.find(params[:id])

      unless order.deposit_paid?
        return redirect_to admin_order_path(order), alert: "Це замовлення вже закрите.", status: :see_other
      end

      Order.transaction do
        case params[:status]
        when "completed"
          order.completed!
          order.cars.each(&:sold!)
        when "cancelled"
          order.cancelled!
          order.cars.each(&:available!)
        end
      end

      redirect_to admin_order_path(order), notice: "Статус замовлення оновлено.", status: :see_other
    end
  end
end