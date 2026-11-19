class Car < ApplicationRecord
  belongs_to :brand
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  enum :status, { available: 0, reserved: 1, sold: 2 }

  validates :name, :year, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 2000 }

  def full_name
    "#{brand.name} #{name}"
  end
end