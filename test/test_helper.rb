ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "securerandom"

# Допоміжні методи створення тестових даних
module TestFactories
  def create_user(admin: false)
    User.create!(
      name: "Тест Користувач",
      email: "user-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      admin: admin
    )
  end

  def create_brand
    Brand.create!(name: "Brand-#{SecureRandom.hex(3)}", country: "Німеччина")
  end

  def create_car(brand: create_brand, price: 40_000, status: :available)
    Car.create!(
      brand: brand, name: "Model-#{SecureRandom.hex(3)}", year: 2026, price: price,
      body_type: "Седан", engine: "2.0", horsepower: 200, transmission: "Автомат",
      drive: "Передній", color: "Сірий", description: "Тестовий автомобіль", status: status
    )
  end

  def create_branch
    Branch.create!(name: "Філія-#{SecureRandom.hex(3)}", city: "Київ",
                   address: "вул. Тестова, 1", phone: "+380440000000")
  end

  # Дата й час у допустимому вікні (за замовчуванням завтра о 10:00)
  def slot_time(days: 1, hour: "10:00")
    Time.zone.parse("#{Date.current + days} #{hour}")
  end

  def create_order(user:, branch:, cars:, deposit: 500)
    order = Order.create!(
      user: user, branch: branch, total_price: cars.sum(&:price), deposit_amount: deposit,
      pickup_at: slot_time, card_last4: "4242", paid_at: Time.current
    )
    cars.each do |car|
      order.order_items.create!(car: car, price: car.price)
      car.reserved!
    end
    order
  end

  def create_test_drive(user:, car:, branch:, time: slot_time)
    TestDrive.create!(user: user, car: car, branch: branch, scheduled_at: time,
                      phone: "+380501234567", license_confirmed: true)
  end
end

class ActiveSupport::TestCase
  include TestFactories
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
