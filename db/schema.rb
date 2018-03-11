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

ActiveRecord::Schema.define(version: 20180311013536) do

  create_table "credit_lines", force: :cascade do |t|
    t.integer "user_id"
    t.string "description"
    t.decimal "limit", precision: 12, scale: 2
    t.decimal "balance", precision: 12, scale: 2
    t.float "interest"
    t.integer "number_of_days"
    t.datetime "currnet_close_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable"
    t.index ["user_id"], name: "index_credit_lines_on_user_id"
  end

  create_table "payment_cycles", force: :cascade do |t|
    t.integer "credit_line_id"
    t.datetime "beginning_date"
    t.datetime "close_date"
    t.decimal "amount", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid"
    t.index ["credit_line_id"], name: "index_payment_cycles_on_credit_line_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "credit_line_id"
    t.decimal "amount", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "option"
    t.float "interest"
    t.decimal "remaining_balance", precision: 12, scale: 2
    t.index ["credit_line_id"], name: "index_transactions_on_credit_line_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "full_name"
    t.string "password_digest"
  end

end
