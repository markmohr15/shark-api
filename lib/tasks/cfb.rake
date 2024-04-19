namespace :importer do

  task :cfb => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'cfb.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'CFB'
    nf = []
    csv.each_entry do |line|
      game = Game.Scheduled.where(sport: sport, gametime: line[:gametime],
                 visitor: sport.teams.where(name: line[:visitor]).first_or_create,
                 home: sport.teams.find_by_name(line[:home])).first_or_initialize
      game.channel = line[:channel]
      game.stadium = Stadium.find_by_name line[:stadium]
      if game.valid?
        game.save!
      else
        nf << line
      end
    end
    
    puts nf
    puts "Finished CFB Import"
  end
end