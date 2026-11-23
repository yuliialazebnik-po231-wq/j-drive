require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "користувач із коректними даними валідний і не є адміністратором" do
    user = User.new(name: "Юлія", email: "yulia@example.com",
                    password: "password123", password_confirmation: "password123")
    assert user.valid?
    assert_not user.admin?
  end

  test "імʼя обовʼязкове" do
    user = User.new(email: "a@example.com", password: "password123")
    assert_not user.valid?
    assert user.errors.of_kind?(:name, :blank)
  end

  test "пароль зберігається у вигляді хешу" do
    user = create_user
    assert_not_equal "password123", user.encrypted_password
    assert user.encrypted_password.start_with?("$2")
  end

  test "повторний email заборонено" do
    first = create_user
    duplicate = User.new(name: "Інший", email: first.email, password: "password123")
    assert_not duplicate.valid?
  end

  test "занадто короткий пароль відхиляється" do
    user = User.new(name: "Юлія", email: "short@example.com", password: "123", password_confirmation: "123")
    assert_not user.valid?
  end
end
