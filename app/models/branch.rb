class Branch < ApplicationRecord
  validates :name, :city, :address, presence: true
end