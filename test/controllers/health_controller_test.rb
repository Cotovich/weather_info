require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "return status 200" do
    get '/health'
    assert_response :success
  end
end
