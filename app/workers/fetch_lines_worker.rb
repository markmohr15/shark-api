class FetchLinesWorker
  include Sidekiq::Worker

  def perform
    BetOnlineLines::Kbo.get_lines
  end
end
