require "test_helper"
require_relative '../../lib/weather_reciever'

class WeatherRecieverTest < ActionDispatch::IntegrationTest
  test 'get current weather' do
    assert_match(/\{:Temperature=>-?[0-9]{1,2}\.[0-9]\}/, WeatherReciever.instance.current_weather.to_s)
  end

  test 'get history of day' do
    assert_equal(24, WeatherReciever.instance.day_history.length)
  end

  test 'get min max avg value of day' do
    assert_match(/\{:Temperature=>-?[0-9]{1,2}\.[0-9]\}/, WeatherReciever.instance.calculate_value('max').to_s)
    assert_match(/\{:Temperature=>-?[0-9]{1,2}\.[0-9]\}/, WeatherReciever.instance.calculate_value('min').to_s)
    assert_match(/\{:Temperature=>-?[0-9]{1,2}\.[0-9]\}/, WeatherReciever.instance.calculate_value('avg').to_s)
  end

  test 'find temperature by time' do
    assert_match(/\{:Temperature=>-?[0-9]{1,2}\.[0-9]\}/,
                 WeatherReciever.instance.find_temperature_by_time(Time.now.to_i - 7200).to_s)

    assert_match('Not in range', WeatherReciever.instance.find_temperature_by_time(Time.now.to_i - 172_800).to_s)

    assert_match('Not in range', WeatherReciever.instance.find_temperature_by_time(Time.now.to_i + 172_800).to_s)
  end
end
