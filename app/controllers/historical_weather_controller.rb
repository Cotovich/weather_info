require_relative '../../lib/weather_reciever.rb'

class HistoricalWeatherController < ApplicationController
  def per_day
    render json: history_of_day
  end

  def per_day_with_calculations
    render json: find_value(params[:type])
  end

  def by_time
    response = find_temperature_by_time(params[:timestamp].to_i)
    if response.is_a? String
      render json: response, status: 404
    else
      render json: response
    end
  end

  private

  def history_of_day
    WeatherReciever.instance.day_history
  end

  def find_value(type)
    WeatherReciever.instance.calculate_value(type)
  end

  def find_temperature_by_time(timestamp)
    WeatherReciever.instance.find_temperature_by_time(timestamp)
  end
end
