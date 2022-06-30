require 'json'
require 'faraday'
require 'faraday/net_http'
Faraday.default_adapter = :net_http

class WeatherReciever
  include Singleton

  def current_weather
    { Temperature: recieve_current_weather }
  end

  def day_history
    temperature_history = []
    temperature_per_day.each do |hour|
      temperature_history.push({ 'ObservationDateTime': hour[:ObservationDateTime], 'Temperature': hour[:Temperature] })
    end
    temperature_history
  end

  def calculate_value(type)
    temperature = []
    temperature_per_day.each { |hour| temperature.push(hour[:Temperature]) }
    case type
    when 'max'
      response = temperature.max
    when 'min'
      response = temperature.min
    when 'avg'
      response = temperature.inject { |sum, el| sum + el }.to_f / temperature.size
      response = response.round(1)
    end
    { Temperature: response }
  end

  def find_temperature_by_time(timestamp)
    found_temperature = 0.0
    ordered_temperature_per_day = temperature_per_day.reverse
    return 'Not in range' if timestamp < ordered_temperature_per_day[0][:Timestamp] || timestamp > ordered_temperature_per_day[-1][:Timestamp]

    ordered_temperature_per_day.each_with_index do |hour, index|
      next if (hour[:Timestamp] - timestamp).negative?

      over_timestamp = hour[:Timestamp]
      under_timestamp = ordered_temperature_per_day[index - 1][:Timestamp]
      desired_timestamp = if over_timestamp - timestamp < timestamp - under_timestamp
                            over_timestamp
                          else
                            under_timestamp
                          end
      found_temperature = temperature_per_day.find { |hour_too| hour_too[:Timestamp] == desired_timestamp }[:Temperature]
      break
    end
    { Temperature: found_temperature }
  end

  private

  def get(path, query, cache)
    if cache
      Rails.cache.fetch(:temperature_per_day, expires_in: 60.minutes) do
        Rails.logger.info 'Recieving data from AccuWeather'
        response = Faraday.new(url: 'http://dataservice.accuweather.com').get(path, query)
        JSON.parse(response.body)
      end
    else
      response = Faraday.new(url: 'http://dataservice.accuweather.com').get(path, query)
      JSON.parse(response.body)
    end
  end

  def recieve_current_weather
    response = get('/currentconditions/v1/294021',
                   { apikey: Rails.application.credentials.accuweather_api_key, language: 'ru-ru' },
                   false)
    response[0]['Temperature']['Metric']['Value']
  end

  def temperature_per_day
    response = get('currentconditions/v1/294021/historical/24',
                   { apikey: Rails.application.credentials.accuweather_api_key, language: 'ru-ru' },
                   true)
    temperature_per_day = []
    response.each do |hour|
      temperature_per_day.push({ 'ObservationDateTime': hour['LocalObservationDateTime'],
                                 'Temperature': hour['Temperature']['Metric']['Value'],
                                 'Timestamp': hour['EpochTime'] })
    end
    temperature_per_day
  end
end
