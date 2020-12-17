namespace :importer do

  task :nba, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nba.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NBA'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, gametime: line[:gametime],
                 visitor: sport.teams.find_by_nickname(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home])).first_or_create
      if game.valid?
        game.update channel: line[:channel]
      else
        nf << line
      end
    end
    
    puts "Finished NBA Import"
    puts nf
  end
end