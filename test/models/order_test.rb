require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @user = create_user
    @branch = create_branch
  end

  def build_order(**overrides)
    Order.new({ user: @user, branch: @branch, total_price: 40_000,
                deposit_amount: 500, pickup_at: slot_time }.merge(overrides))
  end

  test "коректне замовлення валідне, залишок до сплати рахується" do
    order = build_order(deposit_amount: 2_500)
    assert order.valid?
    assert_equal 37_500, order.remaining_amount
  end

  test "застава поза списком допустимих сум відхиляється" do
    assert_not build_order(deposit_amount: 700).valid?
  end

  test "застава не може перевищувати вартість замовлення" do
    assert_not build_order(total_price: 400, deposit_amount: 500).valid?
  end

  test "дата видачі має бути не раніше завтра і не пізніше ніж за 14 днів" do
    assert_not build_order(pickup_at: slot_time(days: 0)).valid?
    assert_not build_order(pickup_at: slot_time(days: 15)).valid?
    assert build_order(pickup_at: slot_time(days: 14)).valid?
  end

  test "час видачі має бути в межах 10:00-17:00" do
    assert_not build_order(pickup_at: slot_time(hour: "09:00")).valid?
    assert_not build_order(pickup_at: slot_time(hour: "18:00")).valid?
    assert build_order(pickup_at: slot_time(hour: "17:00")).valid?
  end

  test "філія обовʼязкова" do
    assert_not build_order(branch: nil).valid?
  end
end
