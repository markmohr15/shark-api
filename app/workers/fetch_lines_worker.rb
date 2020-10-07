class FetchLinesWorker
  include Sidekiq::Worker

  def perform
    begin
      BetOnlineLines::Cfb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Mlb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Nfl.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Kbo.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Npb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Nba.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Nhl.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
  end
end
