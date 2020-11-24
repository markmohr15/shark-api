namespace :importer do

  task :cbb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'cbb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'CBB'
    season = sport.seasons.active.last
    stadium = Stadium.find_by_name 'Unknown'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, stadium: stadium, gametime: line[:gametime],
                 status: "Scheduled", season: season, channel: line[:channel],
                 visitor: sport.teams.where(name: line[:visitor]).first_or_create,
                 home: sport.teams.where(name: line[:home]).first_or_create).first_or_create
      nf << line unless game.valid?
    end

    puts "Finished CBB Import"
    nf.each do |x|
      puts x
    end
  end
end