namespace :importer do

  task :nhl, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nhl.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NHL'
    nf = []
    csv.each_entry do |line|
      game = Game.Scheduled.where(sport: sport,
                 visitor: sport.teams.find_by_nickname(line[:visitor]) || sport.teams.find_by_name(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home]) || sport.teams.find_by_name(line[:home]),
                 gametime: line[:gametime]).first_or_initialize
      game.channel = line[:channel]
      if game.valid?
        game.save!
      else
        nf << line
      end
    end

    puts "Finished NHL Import"
    puts nf
  end
end