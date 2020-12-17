namespace :importer do

  task :mlb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'mlb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'MLB'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, gametime: line[:gametime],
                 visitor: sport.teams.find_by_short_display_name(line[:visitor]),
                 home: sport.teams.find_by_short_display_name(line[:home])).first_or_create
      if game.valid?
        game.update channel: line[:channel]
      else
        nf << line
      end
    end

    puts "Finished MLB Import"
    puts nf
  end
end