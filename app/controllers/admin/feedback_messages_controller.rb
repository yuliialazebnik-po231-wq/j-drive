module Admin
  class FeedbackMessagesController < BaseController
    def index
      @messages = FeedbackMessage.order(handled: :asc, created_at: :desc)
    end

    def update
      message = FeedbackMessage.find(params[:id])
      message.update!(handled: !message.handled)
      redirect_to admin_feedback_messages_path, notice: "Статус повідомлення змінено.", status: :see_other
    end
  end
end
