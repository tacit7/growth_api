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

ActiveRecord::Schema[7.2].define(version: 2025_07_29_132042) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "event_type", null: false
    t.jsonb "metadata", default: {}
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "occurred_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type", "occurred_at"], name: "index_event_logs_on_event_type_and_occurred_at"
    t.index ["event_type"], name: "index_event_logs_on_event_type"
    t.index ["metadata"], name: "index_event_logs_on_metadata", using: :gin
    t.index ["occurred_at"], name: "index_event_logs_on_occurred_at"
    t.index ["user_id", "occurred_at"], name: "index_event_logs_on_user_id_and_occurred_at"
    t.index ["user_id"], name: "index_event_logs_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "event_type"
    t.jsonb "event_data"
    t.datetime "occurred_at"
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["ip_address"], name: "index_events_on_ip_address"
    t.index ["occurred_at"], name: "index_events_on_occurred_at"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.integer "subscription_type"
    t.string "jti"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "event_logs", "users"
  add_foreign_key "events", "users"
end
