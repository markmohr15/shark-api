class LineHelper

  def self.display_spread spr
    case spr
    when blank?
      "" 
    when 0
      "PK"
    when 0..1000
      "+#{spr}"
    else
      spr.to_s
    end
  end

  def self.display_ml ml
    case ml
    when blank?
      ""
    when 100..100000
      "+#{ml}"
    else
      ml.to_s
    end
  end

  def self.display_total over_und, total
    return "" unless total.present?
    text = over_und == "over" ? "Ov" : "Un"
    "#{text} #{total}"
  end

end