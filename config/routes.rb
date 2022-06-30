Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/weather/current', to: 'current_weather#current'
  get '/weather/by_time/:timestamp', to: 'historical_weather#by_time'
  get '/weather/historical', to: 'historical_weather#per_day'
  get '/weather/historical/:type', to: 'historical_weather#per_day_with_calculations'
  get '/health', to: 'health#alive'
end
