class FetchLinesWorker
  include Sidekiq::Worker

  def perform
    Sportsbook.active.each do |s|
      Sport.active.each do |sp|
        begin
          Object.const_get("#{s.name}Lines::#{sp.abbreviation.downcase.titleize}" ).get_lines
        rescue => err
          Sidekiq.logger.info err
          Bugsnag.notify(err)
        end
      end
    end
  end

end
