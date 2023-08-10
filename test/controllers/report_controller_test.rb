require "test_helper"

class ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get report_create_url
    assert_response :success
  end

  test "should get destroy" do
    get report_destroy_url
    assert_response :success
  end
end
