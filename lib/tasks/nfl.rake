namespace :importer do

  task :nfl, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nfl.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NFL'
    season = sport.seasons.active.last
    stadium = Stadium.find_by_name 'Unknown'
    nf = []
    csv.each_entry do |line|
      visitor = sport.teams.where('(nickname || name) ilike ?', "%#{line.first[1]}%").first
      home = sport.teams.where('(nickname || name) ilike ?', "%#{line[:home]}%").first
      game_day = Date.strptime(line[:day], "%m/%d/%y")

      game = Game.where(sport: sport, stadium: stadium, gametime: "#{game_day} #{line[:time]}",
                 status: "Scheduled", season: season, 
                 visitor: visitor, channel: line[:channel],
                 home: home).first_or_create
      unless game.valid?
        nf << line
      end
    end
    puts nf
    puts "Finished NFL Import"
  end
end