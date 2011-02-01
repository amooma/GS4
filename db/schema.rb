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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110201103422) do

  create_table "tests", :force => true do |t|
    t.string   "as"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_to_phones", :force => true do |t|
    t.integer  "user_id"
    t.integer  "phone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_to_sip_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sip_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "gn"
    t.string   "sn"
    t.string   "mail"
    t.string   "userPassword"
    t.string   "telephoneNumber"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
