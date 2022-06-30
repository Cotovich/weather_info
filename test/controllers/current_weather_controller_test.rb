require "test_helper"

class CurrentWeatherControllerTest < ActionDispatch::IntegrationTest
  test 'get correct response for current weather' do
    get '/weather/current'
    assert_match(/{"Temperature":-?[0-9]{1,2}.[0-9]}/, @response.body)
  end
  # test "the truth" do
  #   assert true
  # end
end
