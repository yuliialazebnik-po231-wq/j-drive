module OrdersHelper
  ORDER_STATUS_LABELS = {
    "deposit_paid" => [ "Застава сплачена", "success" ],
    "completed"    => [ "Авто видано", "primary" ],
    "cancelled"    => [ "Скасовано", "secondary" ]
  }.freeze

  def order_status_badge(order)
    label, color = ORDER_STATUS_LABELS.fetch(order.status)
    content_tag(:span, label, class: "badge text-bg-#{color}")
  end
end