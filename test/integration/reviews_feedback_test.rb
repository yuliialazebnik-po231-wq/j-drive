require "test_helper"

class ReviewsFeedbackTest < ActionDispatch::IntegrationTest
  setup do
    @car = create_car
    @user = create_user
  end

  def review_params
    { review: { rating: 5, comment: "Чудове авто, дуже подобається" } }
  end

  test "гість не може залишити відгук" do
    assert_no_difference "Review.count" do
      post car_reviews_path(@car), params: review_params
    end
    assert_redirected_to new_user_session_path
  end

  test "клієнт залишає відгук, але лише один на авто" do
    sign_in @user
    assert_difference "Review.count", 1 do
      post car_reviews_path(@car), params: review_params
    end
    assert_no_difference "Review.count" do
      post car_reviews_path(@car), params: review_params
    end
  end

  test "чужий відгук видалити не можна, власний можна" do
    review = Review.create!(user: @user, car: @car, rating: 5, comment: "Чудове авто")

    sign_in create_user
    assert_no_difference "Review.count" do
      delete car_review_path(@car, review)
    end

    sign_out :user
    sign_in @user
    assert_difference "Review.count", -1 do
      delete car_review_path(@car, review)
    end
  end

  test "адміністратор видаляє будь-який відгук" do
    review = Review.create!(user: @user, car: @car, rating: 3, comment: "Нормальне авто")
    sign_in create_user(admin: true)
    assert_difference "Review.count", -1 do
      delete car_review_path(@car, review)
    end
  end

  test "зворотний звʼязок зберігається в базі" do
    assert_difference "FeedbackMessage.count", 1 do
      post feedback_messages_path, params: { feedback_message: {
        name: "Іван", email: "ivan@example.com", message: "Хочу дізнатися про тест-драйв"
      } }
    end
    assert_not FeedbackMessage.last.handled
  end

  test "некоректне повідомлення зворотного звʼязку не зберігається" do
    assert_no_difference "FeedbackMessage.count" do
      post feedback_messages_path, params: { feedback_message: {
        name: "Іван", email: "abc", message: "ок"
      } }
    end
    assert_response :unprocessable_entity
  end
end
