class BetOnlineLines::Base

  def self.raise_api_error err
    console.log(err)
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

end