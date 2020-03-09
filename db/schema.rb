# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_09_032021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "divisions", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.bigint "league_id", null: false
    t.string "abbreviation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["league_id"], name: "index_divisions_on_league_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "sport_id", null: false
    t.bigint "season_id", null: false
    t.integer "visitor_id"
    t.integer "home_id"
    t.integer "stadium_id"
    t.boolean "neutral", default: false
    t.integer "visitor_score"
    t.integer "home_score"
    t.integer "visitor_rot"
    t.integer "home_rot"
    t.datetime "when"
    t.integer "status"
    t.integer "sportsdata_game_id"
    t.integer "week"
    t.boolean "conference_game", default: false
    t.float "spread"
    t.float "total"
    t.integer "visitor_ml"
    t.integer "home_ml"
    t.integer "visitor_rl"
    t.integer "home_rl"
    t.integer "period"
    t.integer "time_left_min"
    t.integer "time_left_sec"
    t.string "channel"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["season_id"], name: "index_games_on_season_id"
    t.index ["sport_id"], name: "index_games_on_sport_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.bigint "sport_id", null: false
    t.boolean "active", default: true
    t.string "abbreviation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sport_id"], name: "index_leagues_on_sport_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "sport_id", null: false
    t.string "name"
    t.boolean "active", default: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sportsdata_id"
    t.index ["sport_id"], name: "index_seasons_on_sport_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stadiums", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "surface"
    t.integer "altitude"
    t.float "geo_lat"
    t.float "geo_lng"
    t.integer "capacity"
    t.boolean "active", default: true
    t.string "stadium_type"
    t.integer "home_plate_direction"
    t.integer "left_field"
    t.integer "mid_left_field"
    t.integer "left_center_field"
    t.integer "mid_left_center_field"
    t.integer "center_field"
    t.integer "mid_right_center_field"
    t.integer "right_center_field"
    t.integer "mid_right_field"
    t.integer "right_field"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sport_id"
    t.integer "sportsdata_id"
    t.index ["sport_id"], name: "index_stadiums_on_sport_id"
  end

  create_table "subdivisions", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.bigint "division_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["division_id"], name: "index_subdivisions_on_division_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.boolean "active", default: true
    t.bigint "sport_id", null: false
    t.bigint "league_id"
    t.bigint "division_id"
    t.bigint "subdivision_id"
    t.string "short_display_name"
    t.integer "sportsdata_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["division_id"], name: "index_teams_on_division_id"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["sport_id"], name: "index_teams_on_sport_id"
    t.index ["subdivision_id"], name: "index_teams_on_subdivision_id"
  end

  create_table "triggers", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.integer "operator"
    t.float "target"
    t.integer "wager_type"
    t.integer "status", default: 0
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_triggers_on_game_id"
    t.index ["team_id"], name: "index_triggers_on_team_id"
  end

  add_foreign_key "divisions", "leagues"
  add_foreign_key "games", "seasons"
  add_foreign_key "games", "sports"
  add_foreign_key "leagues", "sports"
  add_foreign_key "seasons", "sports"
  add_foreign_key "subdivisions", "divisions"
  add_foreign_key "teams", "divisions"
  add_foreign_key "teams", "leagues"
  add_foreign_key "teams", "sports"
  add_foreign_key "teams", "subdivisions"
  add_foreign_key "triggers", "games"
  add_foreign_key "triggers", "teams"
end
