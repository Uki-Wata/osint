require "test_helper"

class InvestigationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get investigation_index_url
    assert_response :success
  end

  test "should get show" do
    get investigation_show_url
    assert_response :success
  end
end
