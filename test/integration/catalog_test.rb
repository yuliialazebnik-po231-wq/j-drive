require "test_helper"

class CatalogTest < ActionDispatch::IntegrationTest
  test "головна сторінка відкривається" do
    get root_path
    assert_response :success
  end

  test "каталог показує авто" do
    car = create_car
    get cars_path
    assert_response :success
    assert_includes response.body, car.name
  end

  test "фільтр за маркою показує лише авто цієї марки" do
    first = create_car
    second = create_car
    get cars_path(brand_id: first.brand_id)
    assert_includes response.body, first.name
    assert_not_includes response.body, second.name
  end

  test "фільтр за ціною відсікає дорожчі авто" do
    cheap = create_car(price: 20_000)
    expensive = create_car(price: 80_000)
    get cars_path(max_price: 30_000)
    assert_includes response.body, cheap.name
    assert_not_includes response.body, expensive.name
  end

  test "сторінка авто показує його назву" do
    car = create_car
    get car_path(car)
    assert_response :success
    assert_select "h1", car.full_name
  end
end
