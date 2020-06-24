class BetOnlineLines::Base

  def self.raise_api_error message
    #Bugsnag.notify message
    #nil
    throw "#{message}"
  end

end