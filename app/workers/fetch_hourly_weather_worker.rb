class FetchHourlyWeatherWorker
  include Sidekiq::Worker

  def perform
    games = Game.joins(:sport)
                .merge(Sport.weather)
                .where('games.gametime > ? and games.gametime < ?',
                          DateTime.current,
                          DateTime.current + 2.days)
    games.each do |g|
      next if g.stadium.nil?
      hourlies = OpenWeatherApi::Hourly.fetch g.stadium.geo_lat, g.stadium.geo_lng
      next if hourlies.nil?
      hourlies.each do |h|
        weather = g.weathers.where(dt: Time.at(h["dt"]).to_datetime,
                                   report_type: "hourly").first_or_initialize
        weather.update temp: h["temp"].to_i, wind_speed: h["wind_speed"].to_i, 
                       wind_deg: h["wind_deg"], weather: h["weather"][0]["description"].titleize
      end
    end
  end

end

