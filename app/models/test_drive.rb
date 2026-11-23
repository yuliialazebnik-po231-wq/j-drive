class TestDrive < ApplicationRecord
  SLOTS = (10..17).map { |hour| format("%02d:00", hour) }.freeze
  MAX_DAYS = 14

  belongs_to :user
  belongs_to :car
  belongs_to :branch, optional: true

  enum :status, { pending: 0, confirmed: 1, rejected: 2, cancelled: 3 }

  # Віртуальне поле: у базі не зберігається, потрібне лише для галочки у формі
  attribute :license_confirmed, :boolean, default: false

  scope :active, -> { where(status: [ :pending, :confirmed ]) }

  validates :branch_id, presence: { message: "Оберіть філію салону." }
  validates :scheduled_at, presence: { message: "Оберіть дату й час тест-драйву." }
  validates :phone, presence: { message: "Вкажіть телефон для звʼязку." }
    validates :license_confirmed, inclusion: { in: [ true ], message: "Підтвердіть, що маєте посвідчення водія." }, on: :create
  validate :within_allowed_window, on: :create
  validate :car_is_not_sold, on: :create
  validate :no_duplicate_active_booking, on: :create
  validate :slot_is_free, on: :create

  def active?
    pending? || confirmed?
  end

  private

  def within_allowed_window
    return if scheduled_at.blank?

    date = scheduled_at.to_date
    if date < Date.current + 1 || date > Date.current + MAX_DAYS
      errors.add(:scheduled_at, "Дата має бути в межах від завтра до #{MAX_DAYS} днів уперед.")
    end

    unless SLOTS.include?(scheduled_at.strftime("%H:%M"))
      errors.add(:scheduled_at, "Оберіть час зі списку (10:00-17:00).")
    end
  end

  def car_is_not_sold
    errors.add(:car, "Це авто вже продано.") if car&.sold?
  end

  def no_duplicate_active_booking
    return if user_id.blank? || car_id.blank?

    if TestDrive.active.where(user_id: user_id, car_id: car_id).exists?
      errors.add(:car, "У вас уже є активна заявка на тест-драйв цього авто.")
    end
  end

  def slot_is_free
    return if scheduled_at.blank? || car_id.blank?

    if TestDrive.active.where(car_id: car_id, scheduled_at: scheduled_at).exists?
      errors.add(:scheduled_at, "Цей час на обране авто вже зайнятий. Оберіть інший.")
    end
  end
end
