class Review < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :rating, inclusion: { in: 1..5, message: "Оцінка має бути від 1 до 5." }
  validates :comment, presence: { message: "Напишіть текст відгуку." }
  validates :comment, length: { minimum: 5, maximum: 1000, allow_blank: true,
                                message: "Відгук має містити від 5 до 1000 символів." }
  validates :user_id, uniqueness: { scope: :car_id, message: "Ви вже залишили відгук на це авто." }
end
