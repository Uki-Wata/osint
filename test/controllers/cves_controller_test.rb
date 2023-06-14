require "test_helper"

class CvesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cves_index_url
    assert_response :success
  end

  test "should get update" do
    get cves_update_url
    assert_response :success
  end
end
