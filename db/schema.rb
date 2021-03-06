# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171022111717) do

  create_table "angles", force: :cascade do |t|
    t.string "name"
    t.integer "pivot"
    t.decimal "zoom_x", default: "0.0"
    t.decimal "zoom_y", default: "0.0"
    t.decimal "zoom_w", default: "1.0"
    t.decimal "zoom_h", default: "1.0"
  end

  create_table "battle_users", force: :cascade do |t|
    t.integer "battle_id"
    t.string "user_name"
    t.boolean "in"
    t.index ["battle_id"], name: "index_battle_users_on_battle_id"
  end

  create_table "battles", force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.index ["game_id"], name: "index_battles_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.integer "angle_id"
    t.integer "max_players"
    t.index ["angle_id"], name: "index_games_on_angle_id"
  end

end
