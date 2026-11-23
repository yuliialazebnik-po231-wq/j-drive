module ApplicationHelper
  def cart_count
    return 0 unless user_signed_in? && current_user.cart

    current_user.cart.cart_items.count
  end
end
