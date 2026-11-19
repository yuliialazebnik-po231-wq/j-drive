class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_admin

  class CarUnavailable < StandardError; end

  def index
    @orders = current_user.orders.includes(:branch, :cars).order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    load_checkout_data
    return redirect_to(cart_path, alert: "Кошик порожній.") if @items.empty?

    @order = current_user.orders.build(deposit_amount: Order::DEPOSIT_OPTIONS.first)
    @card = CardValidator.new
  end

  def create
    load_checkout_data
    return redirect_to(cart_path, alert: "Кошик порожній.") if @items.empty?

    @order = current_user.orders.build(order_params)
    @order.pickup_at = pickup_time
    @order.total_price = @cart.total_price
    @card = CardValidator.new(**card_params)

    order_valid = @order.valid?
    card_valid = @card.valid?

    if order_valid && card_valid
      place_order
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_checkout_data
    @cart = current_user.current_cart
    @items = @cart.cart_items.includes(car: :brand)
    @branches = Branch.order(:city)
  end

  def order_params
    params.require(:order).permit(:branch_id, :deposit_amount)
  end

  def card_params
    card = params.fetch(:card, {}).permit(:number, :holder, :expiry, :cvv)
    { number: card[:number], holder: card[:holder], expiry: card[:expiry], cvv: card[:cvv] }
  end

  def pickup_time
    return nil if params[:pickup_date].blank? || params[:pickup_time].blank?

    date = Date.iso8601(params[:pickup_date])
    Time.zone.parse("#{date} #{params[:pickup_time]}")
  rescue ArgumentError
    nil
  end

  def place_order
    Order.transaction do
      # lock не дає двом клієнтам одночасно забронювати те саме авто
      cars = Car.lock.where(id: @items.map(&:car_id)).to_a
      raise CarUnavailable unless cars.all?(&:available?)

      @order.card_last4 = @card.last4
      @order.paid_at = Time.current
      @order.save!

      cars.each do |car|
        @order.order_items.create!(car: car, price: car.price)
        car.reserved!
      end

      @cart.cart_items.destroy_all
    end

    redirect_to @order, notice: "Заставу сплачено, автомобіль заброньовано!"
  rescue CarUnavailable
    redirect_to cart_path, alert: "Одне з авто вже недоступне. Приберіть його з кошика й спробуйте ще раз."
  end
end