class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :car

  validates :price, numericality: { greater_than: 0 }
end