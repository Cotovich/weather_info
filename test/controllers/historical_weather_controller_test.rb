require "test_helper"

class HistoricalWeatherControllerTest < ActionDispatch::IntegrationTest
  test 'weather by time correct timestamp' do
    get "/weather/by_time/#{Time.now.to_i - 7200}"
    assert_match(/{"Temperature":-?[0-9]{1,2}.[0-9]}/, @response.body)
  end

  test 'weather by time less timestamp' do
    get "/weather/by_time/#{Time.now.to_i - 172_800}"
    assert_response :missing
  end

  test 'weather by time over timestamp' do
    get "/weather/by_time/#{Time.now.to_i + 172_800}"
    assert_response :missing
  end

  test 'correct historical response' do
    get '/weather/historical'
    assert_equal(24, JSON.parse(@response.body).length)
  end

  test 'correct weather with calculations max' do
    get '/weather/historical/max'
    assert_match(/{"Temperature":-?[0-9]{1,2}.[0-9]}/, @response.body)
  end

  test 'correct weather with calculations min' do
    get '/weather/historical/min'
    assert_match(/{"Temperature":-?[0-9]{1,2}.[0-9]}/, @response.body)
  end

  test 'correct weather with calculations avg' do
    get '/weather/historical/avg'
    assert_match(/{"Temperature":-?[0-9]{1,2}.[0-9]}/, @response.body)
  end
  # test "the truth" do
  #   assert true
  # end
end
