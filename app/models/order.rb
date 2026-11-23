class Order < ApplicationRecord
  DEPOSIT_OPTIONS = [ 500, 1000, 2500, 5000 ].freeze
  PICKUP_SLOTS = (10..17).map { |hour| format("%02d:00", hour) }.freeze
  MAX_PICKUP_DAYS = 14

  belongs_to :user
  belongs_to :branch, optional: true
  has_many :order_items, dependent: :destroy
  has_many :cars, through: :order_items

  enum :status, { deposit_paid: 0, completed: 1, cancelled: 2 }

  validates :branch_id, presence: { message: "Оберіть філію салону." }
  validates :deposit_amount, inclusion: { in: DEPOSIT_OPTIONS, message: "Оберіть суму застави зі списку." }
  validates :pickup_at, presence: { message: "Оберіть дату й час видачі автомобіля." }
  validate :pickup_within_allowed_window, on: :create
  validate :deposit_not_above_total

  def remaining_amount
    total_price - deposit_amount
  end

  private

  def pickup_within_allowed_window
    return if pickup_at.blank?

    date = pickup_at.to_date
    if date < Date.current + 1 || date > Date.current + MAX_PICKUP_DAYS
      errors.add(:pickup_at, "Дата видачі має бути в межах від завтра до #{MAX_PICKUP_DAYS} днів уперед.")
    end

    unless PICKUP_SLOTS.include?(pickup_at.strftime("%H:%M"))
      errors.add(:pickup_at, "Оберіть час видачі зі списку (10:00-17:00).")
    end
  end

  def deposit_not_above_total
    return if deposit_amount.blank? || total_price.blank?

    errors.add(:deposit_amount, "Застава не може бути більшою за вартість замовлення.") if deposit_amount > total_price
  end
end
