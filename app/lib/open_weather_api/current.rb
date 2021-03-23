class OpenWeatherApi::Current < OpenWeatherApi::Base

  def self.fetch lat, lng
    response = get("/onecall?lat=#{lat}&lon=#{lng}&units=imperial&exclude=daily,minutely,hourly,alerts")
    if response.success?
      response["current"]
    else
      raise_api_error response.response
    end
  end

end

