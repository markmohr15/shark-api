namespace :importer do

  task :kbo, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'kbo.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'KBO'
    season = sport.seasons.active.last
    stadium = Stadium.find_by_name 'Unknown'
    csv.each_entry do |line|
      Game.where(sport: sport, stadium: stadium, gametime: line[:gametime],
                 status: "Scheduled", season: season, 
                 visitor: sport.teams.find_by_nickname(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home])).first_or_create
    end

    puts "Finished KBO Import"
  end
end