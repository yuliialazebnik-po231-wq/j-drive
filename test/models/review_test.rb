require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  setup do
    @user = create_user
    @car = create_car
  end

  test "коректний відгук валідний" do
    assert Review.new(user: @user, car: @car, rating: 5, comment: "Чудове авто").valid?
  end

  test "оцінка має бути від 1 до 5" do
    assert_not Review.new(user: @user, car: @car, rating: 0, comment: "Чудове авто").valid?
    assert_not Review.new(user: @user, car: @car, rating: 6, comment: "Чудове авто").valid?
  end

  test "занадто короткий текст відхиляється" do
    assert_not Review.new(user: @user, car: @car, rating: 5, comment: "ок").valid?
  end

  test "один користувач залишає один відгук на авто" do
    Review.create!(user: @user, car: @car, rating: 5, comment: "Чудове авто")
    second = Review.new(user: @user, car: @car, rating: 4, comment: "Ще раз напишу")
    assert_not second.valid?
  end
end
