require "test_helper"

class CartFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
    @car = create_car
    sign_in @user
  end

  test "клієнт додає авто в кошик" do
    assert_difference "CartItem.count", 1 do
      post cart_items_path, params: { car_id: @car.id }
    end
    assert_redirected_to cart_path
    follow_redirect!
    assert_includes response.body, @car.name
  end

  test "те саме авто двічі не додається" do
    post cart_items_path, params: { car_id: @car.id }
    assert_no_difference "CartItem.count" do
      post cart_items_path, params: { car_id: @car.id }
    end
  end

  test "заброньоване авто не додається" do
    reserved = create_car(status: :reserved)
    assert_no_difference "CartItem.count" do
      post cart_items_path, params: { car_id: reserved.id }
    end
  end

  test "клієнт видаляє авто з кошика" do
    item = @user.current_cart.cart_items.create!(car: @car)
    assert_difference "CartItem.count", -1 do
      delete cart_item_path(item)
    end
  end

  test "чужу позицію кошика видалити не можна" do
    item = create_user.current_cart.cart_items.create!(car: @car)
    assert_no_difference "CartItem.count" do
      delete cart_item_path(item)
    end
    assert_response :not_found
  end
end
