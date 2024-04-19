namespace :importer do

  task :cbb, [:csv] => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'cbb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.cbb
    nf = []
    csv.each_entry do |line|
      game = Game.where(sport: sport, gametime: line[:gametime], channel: line[:channel],
                        visitor: sport.tags.where(name: line[:visitor])&.first&.team,
                        home: sport.tags.where(name: line[:home])&.first&.team).first_or_create
      next if game.valid?
      game = Game.where(sport: sport, gametime: line[:gametime], channel: line[:channel],
                        visitor: sport.teams.where(name: line[:visitor]).first_or_create,
                        home: sport.teams.where(name: line[:home]).first_or_create).first_or_create
      next if game.valid?
      nf << line
    end

    puts "Finished CBB Import"
    puts nf
  end
end