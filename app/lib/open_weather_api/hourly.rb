class OpenWeatherApi::Hourly < OpenWeatherApi::Base

  def self.fetch lat, lng
    response = get("/onecall?lat=#{lat}&lon=#{lng}&units=imperial&exclude=current,minutely,daily,alerts")
    if response.success?
      response["hourly"]
    else
      raise_api_error response.response
    end
  end

end