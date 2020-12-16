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
      BookmakerLines::Cfb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BovadaLines::Cfb.get_lines
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
      BookmakerLines::Nfl.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BovadaLines::Nfl.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BetOnlineLines::Cbb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BookmakerLines::Cbb.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BookmakerLines::Cbbe.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BovadaLines::Cbb.get_lines
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
      BookmakerLines::Nba.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    begin
      BovadaLines::Nba.get_lines
    rescue => err
      Sidekiq.logger.info err
      Bugsnag.notify(err)
    end
    #begin
     # BetOnlineLines::Kbo.get_lines
    #rescue => err
     # Sidekiq.logger.info err
      #Bugsnag.notify(err)
    #end
    #begin
     # BetOnlineLines::Npb.get_lines
    #rescue => err
     # Sidekiq.logger.info err
     # Bugsnag.notify(err)
    #end
    #begin
     # BetOnlineLines::Nhl.get_lines
    #rescue => err
     # Sidekiq.logger.info err
      #Bugsnag.notify(err)
    #end
    #begin
     # BetOnlineLines::Mlb.get_lines
    #rescue => err
     # Sidekiq.logger.info err
      #Bugsnag.notify(err)
    #end
  end
end
