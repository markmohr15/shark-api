namespace :importer do

  task :cfb_stadium => [:environment] do |t, args|

    file_path = Rails.root.join('config', 'stadium.csv')
    csv = SmarterCSV.process(file_path, force_utf8: true)
    csv.each_entry do |line|
      begin
        Sport.cfb.teams.find_by_name(line[:team_name]).update stadium_id: line[:stadium_id] 
        stadium = Stadium.find line[:stadium_id]
        stadium.update(name: line[:name], surface: line[:surface], capacity: line[:capacity],
                       geo_lat: line[:geo_lat], geo_lng: line[:geo_lng])
      rescue => err
        puts line
      end 
    end

    puts "Finished CFB Stadium Import"
  end
end


