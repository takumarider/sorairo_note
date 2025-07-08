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

ActiveRecord::Schema[8.0].define(version: 2025_07_08_121827) do
  create_table "menus", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "price", null: false
    t.integer "duration", null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "available", default: true, null: false
    t.bigint "slot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slot_id"], name: "index_menus_on_slot_id"
  end

  create_table "reservations", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "slot_id", null: false
    t.bigint "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_reservations_on_menu_id"
    t.index ["slot_id"], name: "index_reservations_on_slot_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "slots", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.boolean "admin"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "menus", "slots"
  add_foreign_key "reservations", "menus"
  add_foreign_key "reservations", "slots"
  add_foreign_key "reservations", "users"
end
