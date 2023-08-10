require "test_helper"

class Admin::ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_report_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_report_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_report_update_url
    assert_response :success
  end
end
