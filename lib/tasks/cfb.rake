namespace :importer do

  task :cfb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'cfb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'CFB'
    season = sport.seasons.active.last
    stadium = Stadium.find_by_name 'Unknown'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, stadium: stadium, gametime: line[:gametime],
                 status: "Scheduled", season: season, channel: line[:channel],
                 visitor: sport.teams.find_by_name(line[:visitor]),
                 home: sport.teams.find_by_name(line[:home])).first_or_create
      nf << line unless game.valid?
    end

    puts "Finished CFB Import"
    nf.each do |x|
      puts x
    end
  end
end