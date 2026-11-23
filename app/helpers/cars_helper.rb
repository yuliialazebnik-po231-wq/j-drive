module CarsHelper
  STATUS_LABELS = {
    "available" => [ "В наявності", "success" ],
    "reserved"  => [ "Заброньовано", "warning" ],
    "sold"      => [ "Продано", "secondary" ]
  }.freeze

  def car_status_badge(car)
    label, color = STATUS_LABELS.fetch(car.status)
    content_tag(:span, label, class: "badge text-bg-#{color}")
  end

  def format_money(amount)
    number_to_currency(amount, unit: "$", precision: 0, delimiter: " ", format: "%u%n")
  end

  def car_price(car)
    format_money(car.price)
  end

  def rating_stars(rating)
    filled = rating.to_f.round
    ("★" * filled) + ("☆" * (5 - filled))
  end

  def car_photo(car, size: :card)
    css = size == :large ? "car-photo car-photo-lg rounded" : "car-photo"
    slug = "#{car.brand.name} #{car.name}".parameterize

    %w[jpg jpeg png webp].each do |ext|
      file = "cars/#{slug}.#{ext}"
      return image_tag(file, alt: car.full_name, class: css) if Rails.root.join("app/assets/images", file).exist?
    end

    content_tag(:div, car.brand.name, class: css)
  end
end
