# Імітація перевірки банківської картки (навчальний проєкт).
# Реальні гроші не списуються, повний номер картки та CVV ніде не зберігаються.
class CardValidator
  attr_reader :holder, :errors

  def initialize(number: nil, holder: nil, expiry: nil, cvv: nil)
    @number = number.to_s.gsub(/[\s-]/, "")
    @holder = holder.to_s.strip
    @expiry = expiry.to_s.strip
    @cvv = cvv.to_s.strip
    @errors = []
  end

  def valid?
    @errors = []
    validate_number
    validate_holder
    validate_expiry
    validate_cvv
    @errors.empty?
  end

  def last4
    @number.last(4)
  end

  private

  def validate_number
    if !@number.match?(/\A\d{16}\z/)
      @errors << "Номер картки має містити 16 цифр."
    elsif !luhn_valid?(@number)
      @errors << "Номер картки введено неправильно."
    end
  end

  def validate_holder
    @errors << "Вкажіть імʼя власника картки." if @holder.blank?
  end

  def validate_expiry
    match = @expiry.match(%r{\A(0[1-9]|1[0-2])/(\d{2})\z})
    if match.nil?
      @errors << "Термін дії вказуйте у форматі ММ/РР, наприклад 08/28."
    elsif Date.new(2000 + match[2].to_i, match[1].to_i, -1) < Date.current
      @errors << "Термін дії картки минув."
    end
  end

  def validate_cvv
    @errors << "CVV має містити 3 цифри." unless @cvv.match?(/\A\d{3}\z/)
  end

  # Алгоритм Луна: стандартна перевірка контрольної суми номера картки
  def luhn_valid?(digits)
    sum = digits.reverse.chars.each_with_index.sum do |char, index|
      digit = char.to_i
      digit *= 2 if index.odd?
      digit -= 9 if digit > 9
      digit
    end
    (sum % 10).zero?
  end
end
