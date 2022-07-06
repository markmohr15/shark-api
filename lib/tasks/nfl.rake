namespace :importer do

  task :nfl, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nfl.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NFL'
    nf = []
    csv.each_entry do |line|
      visitor = sport.teams.find_by_nickname(line[:visitor]) || sport.teams.find_by_name(line[:visitor])
      home = sport.teams.find_by_nickname(line[:home]) || sport.teams.find_by_name(line[:home])
      game_day = Date.strptime(line[:date], "%m/%d/%y")
      game = Game.Scheduled.where(sport: sport, gametime: "#{game_day} #{line[:time]}",
                                  visitor: visitor, home: home).first_or_initialize
      game.channel = line[:channel]
      if game.valid?
        game.save!
      else
        nf << line
      end
    end
    
    puts nf
    puts "Finished NFL Import"
  end
end