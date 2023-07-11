require "test_helper"

class Public::BookmarkedRecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_bookmarked_recipes_index_url
    assert_response :success
  end

  test "should get show" do
    get public_bookmarked_recipes_show_url
    assert_response :success
  end
end
