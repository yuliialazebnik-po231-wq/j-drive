require "test_helper"

class CarTest < ActiveSupport::TestCase
  test "нове авто за замовчуванням в наявності" do
    car = create_car
    assert car.available?
  end

  test "повна назва складається з марки та моделі" do
    car = create_car
    assert_equal "#{car.brand.name} #{car.name}", car.full_name
  end

  test "ціна має бути більшою за нуль" do
    car = create_car
    car.price = 0
    assert_not car.valid?
  end

  test "рік випуску не може бути раніше 2000" do
    car = create_car
    car.year = 1999
    assert_not car.valid?
  end

  test "назва моделі обовʼязкова" do
    car = create_car
    car.name = ""
    assert_not car.valid?
  end

  test "зміна статусу авто" do
    car = create_car
    car.reserved!
    assert car.reserved?
    car.sold!
    assert car.sold?
  end

  test "середня оцінка рахується за відгуками" do
    car = create_car
    assert_nil car.average_rating
    Review.create!(user: create_user, car: car, rating: 5, comment: "Чудове авто")
    Review.create!(user: create_user, car: car, rating: 4, comment: "Гарне авто")
    assert_equal 4.5, car.reload.average_rating
  end
end
