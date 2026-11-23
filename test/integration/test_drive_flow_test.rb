require "test_helper"

class TestDriveFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
    @car = create_car
    @branch = create_branch
  end

  def drive_params(license: "1")
    {
      test_drive: { branch_id: @branch.id, phone: "+380501234567", comment: "", license_confirmed: license },
      drive_date: (Date.current + 2).iso8601,
      drive_time: "11:00"
    }
  end

  test "клієнт записується на тест-драйв" do
    sign_in @user
    assert_difference "TestDrive.count", 1 do
      post car_test_drives_path(@car), params: drive_params
    end
    assert_redirected_to test_drives_path
  end

  test "без посвідчення водія запис не створюється" do
    sign_in @user
    assert_no_difference "TestDrive.count" do
      post car_test_drives_path(@car), params: drive_params(license: "0")
    end
    assert_response :unprocessable_entity
  end

  test "клієнт скасовує свою заявку" do
    drive = create_test_drive(user: @user, car: @car, branch: @branch)
    sign_in @user
    patch cancel_test_drive_path(drive)
    assert drive.reload.cancelled?
  end

  test "адміністратор підтверджує заявку" do
    drive = create_test_drive(user: @user, car: @car, branch: @branch)
    sign_in create_user(admin: true)
    patch admin_test_drive_path(drive), params: { status: "confirmed" }
    assert drive.reload.confirmed?
  end
end
