namespace :importer do

  task :nba, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nba.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NBA'
    season = sport.seasons.active.last
    stadium = Stadium.find_by_name 'Unknown'
    @nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, stadium: stadium, gametime: line[:gametime],
                 status: "Scheduled", season: season, 
                 visitor: sport.teams.find_by_nickname(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home])).first_or_create
      if game.valid?
        game.update channel: line[:channel]
      else
        @nf << line
      end
    end
    puts "Finished NBA Import"
    puts @nf
  end
end