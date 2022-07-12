class FetchGameTimeWeatherWorker
  include Sidekiq::Worker

  def perform game_id
    g = Game.find game_id
    return if g.stadium.nil?
    weather = OpenWeatherApi::Current.fetch g.stadium.geo_lat, g.stadium.geo_lng
    g.weathers.create dt: Time.at(weather["dt"]).to_datetime,
                      report_type: "current", 
                      temp: weather["temp"].to_i, 
                      wind_speed: weather["wind_speed"].to_i, 
                      wind_deg: weather["wind_deg"], 
                      weather: weather["weather"][0]["description"].titleize
  end

end
