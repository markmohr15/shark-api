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

ActiveRecord::Schema.define(version: 2020_02_10_043240) do

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

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.bigint "sport_id", null: false
    t.boolean "active", default: true
    t.string "abbreviation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sport_id"], name: "index_leagues_on_sport_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subdivisions", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.bigint "division_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["division_id"], name: "index_subdivisions_on_division_id"
  end

  add_foreign_key "divisions", "leagues"
  add_foreign_key "leagues", "sports"
  add_foreign_key "subdivisions", "divisions"
end
