module Admin
  class TestDrivesController < BaseController
    def index
      @test_drives = TestDrive.includes(:user, :branch, car: :brand).order(scheduled_at: :desc)
    end

    def update
      test_drive = TestDrive.find(params[:id])

      if test_drive.pending? && %w[confirmed rejected].include?(params[:status])
        test_drive.update!(status: params[:status])
        redirect_to admin_test_drives_path, notice: "Статус заявки оновлено.", status: :see_other
      else
        redirect_to admin_test_drives_path, alert: "Цю заявку вже опрацьовано.", status: :see_other
      end
    end
  end
end
