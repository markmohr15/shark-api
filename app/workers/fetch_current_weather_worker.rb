class FetchCurrentWeatherWorker
  include Sidekiq::Worker

  def perform
    games = Game.joins(:sport)
                .merge(Sport.weather)
                .where('games.gametime > ? and games.gametime < ?',
                          DateTime.current,
                          DateTime.current + 1.hour)
    games.each do |g|
      next if g.stadium.nil?
      current = OpenWeatherApi::Current.fetch g.stadium.geo_lat, g.stadium.geo_lng
      g.weathers.create dt: Time.at(current["dt"]).to_datetime,
                        report_type: "current"), 
                        temp: current["temp"].to_i, 
                        wind_speed: current["wind_speed"].to_i, 
                        wind_deg: current["wind_deg"], 
                        weather: current["weather"][0]["description"]
    end
  end

end

