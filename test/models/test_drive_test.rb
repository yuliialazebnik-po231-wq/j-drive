require "test_helper"

class TestDriveTest < ActiveSupport::TestCase
  setup do
    @user = create_user
    @car = create_car
    @branch = create_branch
  end

  def build_drive(**overrides)
    TestDrive.new({ user: @user, car: @car, branch: @branch, scheduled_at: slot_time,
                    phone: "+380501234567", license_confirmed: true }.merge(overrides))
  end

  test "коректна заявка валідна й очікує підтвердження" do
    drive = build_drive
    assert drive.valid?
    assert drive.pending?
  end

  test "без підтвердження посвідчення водія заявка відхиляється" do
    assert_not build_drive(license_confirmed: false).valid?
  end

  test "дата має бути не раніше завтра" do
    assert_not build_drive(scheduled_at: slot_time(days: 0)).valid?
  end

  test "не можна мати дві активні заявки на те саме авто" do
    create_test_drive(user: @user, car: @car, branch: @branch)
    assert_not build_drive(scheduled_at: slot_time(hour: "11:00")).valid?
  end

  test "зайнятий час на авто не може бути обраний іншим клієнтом" do
    create_test_drive(user: @user, car: @car, branch: @branch)
    assert_not build_drive(user: create_user).valid?
  end

  test "після скасування можна записатися знову" do
    first = create_test_drive(user: @user, car: @car, branch: @branch)
    first.update_column(:status, TestDrive.statuses[:cancelled])
    assert build_drive.valid?
  end

  test "на продане авто записатися не можна" do
    @car.sold!
    assert_not build_drive.valid?
  end
end
