class OpenWeatherApi::Daily < OpenWeatherApi::Base

  def self.get_daily lat, lng
    response = get("/onecall?lat=#{lat}&lon=#{lng}&units=imperial&exclude=current,minutely,hourly,alerts")
    if response.success?
      byebug
    else
      byebug
      raise_api_error response.response
    end
  end


end