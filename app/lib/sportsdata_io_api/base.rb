class SportsdataIoApi::Base
  include HTTParty
  base_uri Rails.application.credentials[:SPORTSDATA_IO_API_URL]
  default_params key: Rails.application.credentials[:SPORTSDATA_IO_API_KEY]

  def self.raise_api_error message
    #Bugsnag.notify message
    #nil
    throw "#{message}"
  end

  def self.sport
    Sport.send(self.to_s.split("::")[1].downcase)
  end

  def self.teams
    sport.teams
  end

  def self.stadiums
    sport.stadiums
  end

  def self.headers
    {"Content-Type" => "application/json"}
  end

end