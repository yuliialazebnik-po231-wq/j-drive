require "test_helper"

class AccessTest < ActionDispatch::IntegrationTest
  test "реєстрація створює користувача" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: { user: {
        name: "Юлія", phone: "+380501112233", email: "new@example.com",
        password: "password123", password_confirmation: "password123"
      } }
    end
  end

  test "реєстрація без імені не створює користувача" do
    assert_no_difference "User.count" do
      post user_registration_path, params: { user: {
        name: "", email: "noname@example.com",
        password: "password123", password_confirmation: "password123"
      } }
    end
  end

  test "гість перенаправляється на вхід із кошика, замовлень і тест-драйвів" do
    [ cart_path, new_order_path, test_drives_path ].each do |path|
      get path
      assert_redirected_to new_user_session_path
    end
  end

  test "клієнт не має доступу до адмін-панелі" do
    sign_in create_user
    get admin_root_path
    assert_redirected_to root_path
  end

  test "адміністратор бачить адмін-панель" do
    sign_in create_user(admin: true)
    get admin_root_path
    assert_response :success
  end

  test "адміністратора не пускає до кошика клієнта" do
    sign_in create_user(admin: true)
    get cart_path
    assert_redirected_to admin_root_path
  end
end
