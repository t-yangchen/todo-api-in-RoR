ActiveRecord::Schema.define(version: 2020_10_16_091043) do

  create_table "tasks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "taskname"
    t.boolean "iscomplete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.boolean "isadmin", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "username"
  end

  add_foreign_key "tasks", "users"
end
