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

ActiveRecord::Schema.define(:version => 20110327194450) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extensions", :force => true do |t|
    t.integer  "sip_user_id"
    t.integer  "extension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provisioning_servers", :force => true do |t|
    t.string   "name"
    t.integer  "port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "auth_name"
    t.string   "password"
    t.string   "realm"
    t.integer  "phone_number"
    t.integer  "sip_server_id"
    t.integer  "sip_proxy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "extension_id"
    t.integer  "sip_phone_id"
    t.integer  "voicemail_pin"
    t.integer  "position"
    t.integer  "voicemail_server_id"
  end

  create_table "sip_phones", :force => true do |t|
    t.integer  "phone_id"
    t.integer  "provisioning_server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_proxies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "host"
    t.integer  "host_port"
    t.string   "management_host"
    t.integer  "management_host_port"
  end

  create_table "sip_servers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "managed_by_gs"
    t.string   "host"
    t.integer  "management_port"
    t.integer  "port"
    t.string   "management_host"
  end

  create_table "tests", :force => true do |t|
    t.string   "as"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "sn"
    t.string   "gn"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "voicemail_servers", :force => true do |t|
    t.string   "host"
    t.integer  "port"
    t.string   "management_host"
    t.integer  "management_port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
