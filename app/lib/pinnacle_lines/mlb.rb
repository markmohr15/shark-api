class PinnacleLines::Mlb < PinnacleLines::Base

  def self.league_id
    246
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.game_info game, preseason = false
    pin_game_id = game["id"]
    vis_name = game["participants"].find {|x| x["alignment"] == "away"}["name"].split("(")[0].squish
    home_name = game["participants"].find {|x| x["alignment"] == "home"}["name"].split("(")[0].squish
    time = "#{game["startTime"]} GMT".to_datetime
    correct_lines = linepicker(preseason)
    spread_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["isAlternate"] == false && l["type"] == "spread" && l["prices"][0]["points"].abs == 1.5}
    ml_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["isAlternate"] == false && l["type"] == "moneyline"}
    total_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["isAlternate"] == false && l["type"] == "total" && l["period"] == 0}
    vis_spread = vis_rl = home_rl = total = vis_ml = home_ml = over_juice = under_juice = nil
    if spread_line
      vis = spread_line["prices"].find{|sl| sl["designation"] == "away"}
      home = spread_line["prices"].find{|sl| sl["designation"] == "home"}
      vis_spread = vis["points"].to_f
      vis_rl = vis["price"]
      home_rl = home["price"]
    end
    if total_line
      total = total_line["prices"][0]["points"]
      over_juice = total_line["prices"].find {|x| x["designation"] == "over"}["price"]
      under_juice = total_line["prices"].find {|x| x["designation"] == "under"}["price"]
    end
    if ml_line
      vis_ml = ml_line["prices"].find {|x| x["designation"] == "away"}["price"]
      home_ml = ml_line["prices"].find {|x| x["designation"] == "home"}["price"]
    end
    {vis_name: vis_name, home_name: home_name, time: time, vis_spread: vis_spread,
     vis_rl: vis_rl, home_rl: home_rl, total: total, vis_ml: vis_ml, home_ml: home_ml,
     over_juice: over_juice, under_juice: under_juice }
  end
  
end