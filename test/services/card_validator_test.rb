require "test_helper"

class CardValidatorTest < ActiveSupport::TestCase
  def card(**overrides)
    CardValidator.new(**{ number: "4242 4242 4242 4242", holder: "IVAN PETRENKO",
                          expiry: "12/99", cvv: "123" }.merge(overrides))
  end

  test "коректна картка проходить перевірку, зберігаються лише 4 цифри" do
    validator = card
    assert validator.valid?
    assert_equal "4242", validator.last4
  end

  test "номер із неправильною контрольною сумою відхиляється" do
    assert_not card(number: "1234567812345678").valid?
  end

  test "номер неправильної довжини відхиляється" do
    assert_not card(number: "4242").valid?
  end

  test "прострочена картка відхиляється" do
    assert_not card(expiry: "01/20").valid?
  end

  test "неправильний формат терміну відхиляється" do
    assert_not card(expiry: "13/30").valid?
  end

  test "CVV має містити 3 цифри" do
    assert_not card(cvv: "12").valid?
  end

  test "імʼя власника обовʼязкове" do
    assert_not card(holder: "").valid?
  end
end
