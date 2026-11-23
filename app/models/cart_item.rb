class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :car

  validates :car_id, uniqueness: { scope: :cart_id }
  validate :car_must_be_available, on: :create

  private

  def car_must_be_available
    errors.add(:car, "недоступне для замовлення") unless car&.available?
  end
end
