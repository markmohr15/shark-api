namespace :importer do

  task :nhl, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'nhl.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NHL'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, gametime: line[:gametime],
                 visitor: sport.teams.find_by_nickname(line[:visitor]),
                 home: sport.teams.find_by_nickname(line[:home])).first_or_create
      nf << line unless game.valid?
    end

    puts "Finished NHL Import"
    puts nf
  end
end