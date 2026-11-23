class FeedbackMessagesController < ApplicationController
  before_action :load_branches

  def new
    @feedback = FeedbackMessage.new
    return unless user_signed_in?

    @feedback.name = current_user.name
    @feedback.email = current_user.email
  end

  def create
    @feedback = FeedbackMessage.new(feedback_params)

    if @feedback.save
      redirect_to root_path, notice: "Дякуємо! Ми відповімо вам найближчим часом."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_branches
    @branches = Branch.order(:city)
  end

  def feedback_params
    params.require(:feedback_message).permit(:name, :email, :message)
  end
end
