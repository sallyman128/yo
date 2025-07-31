require "test_helper"

class PushNotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get push_notifications_create_url
    assert_response :success
  end

  test "should get send_notification" do
    get push_notifications_send_notification_url
    assert_response :success
  end
end
