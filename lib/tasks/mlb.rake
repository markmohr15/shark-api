namespace :importer do

  task :mlb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'mlb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'MLB'
    nf = []
    csv.each_entry do |line|
      game = Game.Scheduled.where(sport: sport, gametime: line[:date] + " " + line[:time] + " " + "CDT",
                 visitor: sport.teams.find_by_nickname(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home])).first_or_initialize
      game.channel = line[:channel]
      if game.valid?
        game.save!
      else
        nf << line
      end
    end

    puts "Finished MLB Import"
    puts nf
  end
end