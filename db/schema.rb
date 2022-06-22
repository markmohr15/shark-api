# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_22_145401) do

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
    t.datetime "gametime"
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
    t.index ["gametime"], name: "index_games_on_gametime"
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

  create_table "lines", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "sportsbook_id"
    t.integer "home_rl"
    t.integer "home_ml"
    t.float "home_spread"
    t.integer "visitor_rl"
    t.integer "visitor_ml"
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "visitor_spread"
    t.integer "over_odds"
    t.integer "under_odds"
    t.index ["created_at"], name: "index_lines_on_created_at"
    t.index ["game_id"], name: "index_lines_on_game_id"
    t.index ["sportsbook_id"], name: "index_lines_on_sportsbook_id"
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

  create_table "sportsbooks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "abbreviation"
    t.boolean "active", default: true
  end

  create_table "sportsbooks_users", id: false, force: :cascade do |t|
    t.bigint "sportsbook_id", null: false
    t.bigint "user_id", null: false
    t.index ["sportsbook_id"], name: "index_sportsbooks_users_on_sportsbook_id"
    t.index ["user_id"], name: "index_sportsbooks_users_on_user_id"
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

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_tags_on_team_id"
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
    t.string "bookmaker_name"
    t.string "bovada_name"
    t.bigint "stadium_id"
    t.index ["division_id"], name: "index_teams_on_division_id"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["sport_id"], name: "index_teams_on_sport_id"
    t.index ["stadium_id"], name: "index_teams_on_stadium_id"
    t.index ["subdivision_id"], name: "index_teams_on_subdivision_id"
  end

  create_table "triggers", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.integer "operator"
    t.float "target"
    t.integer "wager_type"
    t.integer "status", default: 0
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.datetime "gametime"
    t.boolean "notified", default: false
    t.index ["game_id"], name: "index_triggers_on_game_id"
    t.index ["gametime"], name: "index_triggers_on_gametime"
    t.index ["team_id"], name: "index_triggers_on_team_id"
    t.index ["user_id"], name: "index_triggers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "jti", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "weathers", force: :cascade do |t|
    t.datetime "dt"
    t.integer "temp"
    t.integer "high"
    t.integer "low"
    t.integer "day"
    t.integer "morn"
    t.integer "eve"
    t.integer "night"
    t.integer "wind_speed"
    t.integer "wind_deg"
    t.string "weather"
    t.bigint "game_id", null: false
    t.integer "report_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_weathers_on_game_id"
  end

  add_foreign_key "divisions", "leagues"
  add_foreign_key "games", "seasons"
  add_foreign_key "games", "sports"
  add_foreign_key "leagues", "sports"
  add_foreign_key "seasons", "sports"
  add_foreign_key "sportsbooks_users", "sportsbooks"
  add_foreign_key "sportsbooks_users", "users"
  add_foreign_key "subdivisions", "divisions"
  add_foreign_key "teams", "divisions"
  add_foreign_key "teams", "leagues"
  add_foreign_key "teams", "sports"
  add_foreign_key "teams", "subdivisions"
  add_foreign_key "triggers", "games"
  add_foreign_key "triggers", "teams"
  add_foreign_key "triggers", "users"
  add_foreign_key "weathers", "games"
end
