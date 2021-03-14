class OpenWeatherApi::Base
  include HTTParty
  base_uri Rails.application.credentials[:OPEN_WEATHER_API_URL]
  default_params appid: Rails.application.credentials[:OPEN_WEATHER_API_KEY]

  def self.raise_api_error message
    #Bugsnag.notify message
    #nil
    throw "#{message}"
  end

end