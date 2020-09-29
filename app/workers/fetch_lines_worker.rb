class FetchLinesWorker
  include Sidekiq::Worker

  def perform
    begin
      BetOnlineLines::Cfb.get_lines
      BetOnlineLines::Kbo.get_lines
      BetOnlineLines::Mlb.get_lines
      BetOnlineLines::Nba.get_lines
      BetOnlineLines::Nfl.get_lines
      BetOnlineLines::Nhl.get_lines
      BetOnlineLines::Npb.get_lines
    rescue => err 
      Sidekiq.logger.info err
    end
  end
end
