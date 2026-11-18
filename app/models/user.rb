class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy

  validates :name, presence: true

  def current_cart
    cart || create_cart
  end
end