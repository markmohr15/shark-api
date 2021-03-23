class OpenWeatherApi::Daily < OpenWeatherApi::Base

  def self.fetch lat, lng
    response = get("/onecall?lat=#{lat}&lon=#{lng}&units=imperial&exclude=current,minutely,hourly,alerts")
    if response.success?
      response["daily"]
    else
      raise_api_error response.response
    end
  end

end