namespace :importer do

  task :npb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'npb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'NPB'
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, gametime: line[:gametime],
                        visitor: sport.teams.find_by_name(line[:visitor]),
                        home: sport.teams.find_by_name(line[:home])).first_or_create
      nf << line unless game.valid?
    end

    puts "Finished NPB Import"
    puts nf
  end
end