class FeedbackMessage < ApplicationRecord
  validates :name, presence: { message: "Вкажіть ваше імʼя." }
  validates :email, presence: { message: "Вкажіть email." }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true,
                              message: "Email введено неправильно." }
  validates :message, presence: { message: "Напишіть повідомлення." }
  validates :message, length: { minimum: 10, maximum: 2000, allow_blank: true,
                                message: "Повідомлення має містити від 10 до 2000 символів." }
end