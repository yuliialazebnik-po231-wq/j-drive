module Admin
  class CartItemsController < BaseController
    def destroy
      user = User.find(params[:user_id])
      item = CartItem.joins(:cart).where(carts: { user_id: user.id }).find(params[:id])
      item.destroy
      redirect_to admin_user_path(user), notice: "Позицію видалено з кошика користувача.", status: :see_other
    end
  end
end
