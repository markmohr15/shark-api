class FetchDailyWeatherWorker
  include Sidekiq::Worker

  def perform
    games = Game.joins(:sport)
                .merge(Sport.weather)
                .where('games.gametime > ? and games.gametime < ?',
                          DateTime.current + 2.days,
                          DateTime.current + 7.days)
    games.each do |g|
      next if g.stadium.nil?
      dailys = OpenWeatherApi::Daily.fetch g.stadium.geo_lat, g.stadium.geo_lng
      dailys.each do |d|
        weather = g.weathers.where(dt: Time.at(d["dt"]).to_datetime, 
                                   report_type: "daily").first_or_initialize
        temp = d["temp"]
        weather.update day: temp["day"].to_i, low: temp["min"].to_i, high: temp["max"].to_i, 
                       eve: temp["eve"].to_i, night: temp["night"].to_i, morn: temp["morn"].to_i,
                       wind_speed: d["wind_speed"].to_i, wind_deg: d["wind_deg"],
                       weather: d["weather"][0]["description"].titleize
      end
    end
  end

end
