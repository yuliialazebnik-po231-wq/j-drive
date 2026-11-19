class TestDrivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car, only: %i[new create]

  def index
    @test_drives = current_user.test_drives.includes({ car: :brand }, :branch).order(scheduled_at: :desc)
  end

  def new
    return redirect_to(car_path(@car), alert: "Це авто вже продано.") if @car.sold?

    @test_drive = current_user.test_drives.build(car: @car, phone: current_user.phone)
  end

  def create
    @test_drive = current_user.test_drives.build(test_drive_params.merge(car: @car))
    @test_drive.scheduled_at = scheduled_time

    if @test_drive.save
      redirect_to test_drives_path, notice: "Заявку надіслано! Менеджер підтвердить її найближчим часом."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    test_drive = current_user.test_drives.find(params[:id])

    if test_drive.active?
      test_drive.cancelled!
      redirect_to test_drives_path, notice: "Запис скасовано.", status: :see_other
    else
      redirect_to test_drives_path, alert: "Цей запис уже не можна скасувати.", status: :see_other
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
    @branches = Branch.order(:city)
  end

  def test_drive_params
    params.require(:test_drive).permit(:branch_id, :phone, :comment, :license_confirmed)
  end

  def scheduled_time
    return nil if params[:drive_date].blank? || params[:drive_time].blank?

    date = Date.iso8601(params[:drive_date])
    Time.zone.parse("#{date} #{params[:drive_time]}")
  rescue ArgumentError
    nil
  end
end