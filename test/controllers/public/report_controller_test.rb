require "test_helper"

class Public::ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_report_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_report_destroy_url
    assert_response :success
  end
end
