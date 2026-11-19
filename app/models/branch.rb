class Branch < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, :city, :address, presence: true

  def full_address
    "#{name} — #{address}"
  end
end