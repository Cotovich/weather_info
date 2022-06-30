require_relative '../../lib/weather_reciever.rb'

class CurrentWeatherController < ApplicationController
  def current
    render json: current_weather
  end

  private

  def current_weather
    WeatherReciever.instance.current_weather
  end
end
