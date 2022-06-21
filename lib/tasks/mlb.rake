namespace :importer do

  task :mlb, [:filename] => [:environment] do |t, args|
    ee = File.open(args[:filename])
    text = ee.read
    file_path = "#{Rails.root.join("tmp")}/importing.csv"
    File.open(file_path, "w") do |f| f.write(text) end
    csv = SmarterCSV.process(file_path, force_utf8: true)
    sport = Sport.find_by_abbreviation 'MLB'
    nf = []
    csv.each_entry do |line|
      visitor = sport.teams.find_by_nickname(line[:visitor]) || sport.teams.find_by_name(line[:visitor])
      home = sport.teams.find_by_nickname(line[:home]) || sport.teams.find_by_name(line[:home])
      game = Game.Scheduled.where(sport: sport, gametime: line[:date] + " " + line[:time] + " " + "CDT",
                                  visitor: visitor, home: home).first_or_initialize
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