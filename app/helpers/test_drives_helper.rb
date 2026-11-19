module TestDrivesHelper
  TEST_DRIVE_LABELS = {
    "pending"   => [ "Очікує підтвердження", "warning" ],
    "confirmed" => [ "Підтверджено", "success" ],
    "rejected"  => [ "Відхилено", "danger" ],
    "cancelled" => [ "Скасовано", "secondary" ]
  }.freeze

  def test_drive_status_badge(test_drive)
    label, color = TEST_DRIVE_LABELS.fetch(test_drive.status)
    content_tag(:span, label, class: "badge text-bg-#{color}")
  end
end