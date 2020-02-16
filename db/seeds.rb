# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

mlb = Sport.where(name: "Major League Baseball", abbreviation: "MLB").first_or_create
nfl = Sport.where(name: "National Football League", abbreviation: "NFL").first_or_create
nba = Sport.where(name: "National Basketball Association", abbreviation: "NBA").first_or_create
nhl = Sport.where(name: "National Hockey League", abbreviation: "NHL").first_or_create
ncaaf = Sport.where(name: "College Football", abbreviation: "CFB").first_or_create
ncaab = Sport.where(name: "College Basketball", abbreviation: "CBB").first_or_create

nl = mlb.leagues.where(name: "National League", abbreviation: "NL").first_or_create
al = mlb.leagues.where(name: "America League", abbreviation: "AL").first_or_create
nfc = nfl.leagues.where(name: "National Football Conference", abbreviation: "NFC").first_or_create
afc = nfl.leagues.where(name: "American Football Conference", abbreviation: "AFC").first_or_create
ec = nba.leagues.where(name: "Eastern Conference", abbreviation: "East").first_or_create
wc = nba.leagues.where(name: "Western Conference", abbreviation: "West").first_or_create
hec = nhl.leagues.where(name: "Eastern Conference", abbreviation: "East").first_or_create
hwc = nhl.leagues.where(name: "Western Conference", abbreviation: "West").first_or_create
fbs = ncaaf.leagues.where(name: "Football Bowl Subdivision", abbreviation: "FBS").first_or_create
fcs = ncaaf.leagues.where(name: "Football Championship Subdivision", abbreviation: "FCS").first_or_create
d1 = ncaab.leagues.where(name: "Division One", abbreviation: "D1").first_or_create

nl.divisions.where(name: "National League East", abbreviation: "NL East").first_or_create
nl.divisions.where(name: "National League Central", abbreviation: "NL Central").first_or_create
nl.divisions.where(name: "National League West", abbreviation: "NL West").first_or_create
al.divisions.where(name: "American League East", abbreviation: "AL East").first_or_create
al.divisions.where(name: "American League Central", abbreviation: "AL Central").first_or_create
al.divisions.where(name: "American League West", abbreviation: "AL West").first_or_create

nfc.divisions.where(name: "NFC East").first_or_create
nfc.divisions.where(name: "NFC West").first_or_create
nfc.divisions.where(name: "NFC North").first_or_create
nfc.divisions.where(name: "NFC South").first_or_create
afc.divisions.where(name: "AFC East").first_or_create
afc.divisions.where(name: "AFC West").first_or_create
afc.divisions.where(name: "AFC North").first_or_create
afc.divisions.where(name: "AFC South").first_or_create

ec.divisions.where(name: "Atlantic").first_or_create
ec.divisions.where(name: "Central").first_or_create
ec.divisions.where(name: "Southeast").first_or_create
wc.divisions.where(name: "Northwest").first_or_create
wc.divisions.where(name: "Pacific").first_or_create
wc.divisions.where(name: "Southwest").first_or_create

hec.divisions.where(name: "Metropolitan").first_or_create
hec.divisions.where(name: "Atlantic").first_or_create
hwc.divisions.where(name: "Central").first_or_create
hwc.divisions.where(name: "Pacific").first_or_create

acc = fbs.divisions.where(name: "Atlantic Coast Conference", abbreviation: "ACC").first_or_create
aac = fbs.divisions.where(name: "American Athletic Conference", abbreviation: "AAC").first_or_create
fbs.divisions.where(name: "Big 12 Conference", abbreviation: "Big 12").first_or_create
bt = fbs.divisions.where(name: "Big Ten Conference", abbreviation: "Big 10").first_or_create
cusa = fbs.divisions.where(name: "Conference USA", abbreviation: "CUSA").first_or_create
fbs.divisions.where(name: "FBS Independents", abbreviation: "Indy (FBS)").first_or_create
mac = fbs.divisions.where(name: "Mid-American Conference", abbreviation: "MAC").first_or_create
mwc = fbs.divisions.where(name: "Mountain West Conference", abbreviation: "MWC").first_or_create
pt = fbs.divisions.where(name: "Pac-12 Conference", abbreviation: "Pac 12").first_or_create
sec = fbs.divisions.where(name: "Southeastern Conference", abbreviation: "SEC").first_or_create
sbc = fbs.divisions.where(name: "Sun Belt Conference", abbreviation: "SBC").first_or_create

fcs.divisions.where(name: "Big Sky Conference", abbreviation: "Big Sky").first_or_create
fcs.divisions.where(name: "Big South Conference", abbreviation: "Big South").first_or_create
fcs.divisions.where(name: "Colonial Athletic Association", abbreviation: "CAA").first_or_create
fcs.divisions.where(name: "Independents (FCS)", abbreviation: "Indy (FCS)").first_or_create
fcs.divisions.where(name: "Ivy League", abbreviation: "Ivy").first_or_create
fcs.divisions.where(name: "Mid-Eastern Athletic Conference", abbreviation: "MEAC").first_or_create
fcs.divisions.where(name: "Missouri Valley Conference", abbreviation: "MVC").first_or_create
fcs.divisions.where(name: "Northeast Conference", abbreviation: "MEAC").first_or_create
fcs.divisions.where(name: "Mid-Eastern Athletic Conference", abbreviation: "NEC").first_or_create
fcs.divisions.where(name: "Ohio Valley Conference", abbreviation: "OVC").first_or_create
fcs.divisions.where(name: "Patriot League", abbreviation: "Patriot").first_or_create
fcs.divisions.where(name: "Pioneer League", abbreviation: "Pioneer").first_or_create
fcs.divisions.where(name: "Southern Conference", abbreviation: "Southern").first_or_create
fcs.divisions.where(name: "Southland Conference", abbreviation: "Southland").first_or_create
swac = fcs.divisions.where(name: "Southwestern Athletic Conference", abbreviation: "SWAC").first_or_create

acc.subdivisions.where(name: "Atlantic").first_or_create
acc.subdivisions.where(name: "Coastal").first_or_create
aac.subdivisions.where(name: "East").first_or_create
aac.subdivisions.where(name: "West").first_or_create
bt.subdivisions.where(name: "East").first_or_create
bt.subdivisions.where(name: "West").first_or_create
cusa.subdivisions.where(name: "East").first_or_create
cusa.subdivisions.where(name: "West").first_or_create
mac.subdivisions.where(name: "East").first_or_create
mac.subdivisions.where(name: "West").first_or_create
mwc.subdivisions.where(name: "Mountain").first_or_create
mwc.subdivisions.where(name: "West").first_or_create
pt.subdivisions.where(name: "North").first_or_create
pt.subdivisions.where(name: "South").first_or_create
sec.subdivisions.where(name: "East").first_or_create
sec.subdivisions.where(name: "West").first_or_create
sbc.subdivisions.where(name: "East").first_or_create
sbc.subdivisions.where(name: "West").first_or_create
swac.subdivisions.where(name: "East").first_or_create
swac.subdivisions.where(name: "West").first_or_create

d1.divisions.where(name: "America East Conference", abbreviation: "AEC").first_or_create
d1.divisions.where(name: "American Athletic Conference", abbreviation: "AAC").first_or_create
d1.divisions.where(name: "Atlantic 10 Conference", abbreviation: "A10").first_or_create
d1.divisions.where(name: "Atlantic Coast Conference", abbreviation: "ACC").first_or_create
d1.divisions.where(name: "Atlantic Sun Conference", abbreviation: "ASUN").first_or_create
d1.divisions.where(name: "Big 12 Conference", abbreviation: "Big 12").first_or_create
d1.divisions.where(name: "Big East Conference", abbreviation: "Big East").first_or_create
d1.divisions.where(name: "Big Sky Conference", abbreviation: "Big Sky").first_or_create
d1.divisions.where(name: "Big South Conference", abbreviation: "Big South").first_or_create
d1.divisions.where(name: "Big Ten Conference", abbreviation: "Big Ten").first_or_create
d1.divisions.where(name: "Big West Conference", abbreviation: "Big West").first_or_create
d1.divisions.where(name: "Colonial Athletic Association", abbreviation: "CAA").first_or_create
d1.divisions.where(name: "Conference USA", abbreviation: "CUSA").first_or_create
d1.divisions.where(name: "Horizon League", abbreviation: "Horizon").first_or_create
d1.divisions.where(name: "Ivy League", abbreviation: "Ivy").first_or_create
d1.divisions.where(name: "Metro Atlantic Athletic Conference", abbreviation: "MAAC").first_or_create
macb = d1.divisions.where(name: "Mid-American Conference", abbreviation: "MAC").first_or_create
d1.divisions.where(name: "Mid-Eastern Athletic Conference", abbreviation: "MEAC").first_or_create
d1.divisions.where(name: "Missouri Valley Conference", abbreviation: "MVC").first_or_create
d1.divisions.where(name: "Mountain West Conference", abbreviation: "MWC").first_or_create
d1.divisions.where(name: "Northeast Conference", abbreviation: "NEC").first_or_create
d1.divisions.where(name: "Ohio Valley Conference", abbreviation: "OVC").first_or_create
d1.divisions.where(name: "Pac-12 Conference", abbreviation: "Pac 12").first_or_create
d1.divisions.where(name: "Patriot League", abbreviation: "Patriot").first_or_create
d1.divisions.where(name: "Southeastern Conference", abbreviation: "SEC").first_or_create
d1.divisions.where(name: "Southern Conference", abbreviation: "Southern").first_or_create
d1.divisions.where(name: "Southland Conference", abbreviation: "Southland").first_or_create
d1.divisions.where(name: "Southwestern Athletic Conference", abbreviation: "SWAC").first_or_create
d1.divisions.where(name: "Summit League", abbreviation: "Summit").first_or_create
d1.divisions.where(name: "Sun Belt Conference", abbreviation: "SBC").first_or_create
d1.divisions.where(name: "West Coast Conference", abbreviation: "WCC").first_or_create
d1.divisions.where(name: "Western Athletic Conference", abbreviation: "WAC").first_or_create

macb.subdivisions.where(name: "East").first_or_create
macb.subdivisions.where(name: "West").first_or_create











