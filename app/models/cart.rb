class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :cars, through: :cart_items

  def total_price
    cars.sum(:price)
  end
end
