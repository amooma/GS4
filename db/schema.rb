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

ActiveRecord::Schema.define(:version => 20110908125305) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "call_forward_reasons", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "call_forwards", :force => true do |t|
    t.integer  "sip_account_id"
    t.integer  "call_forward_reason_id"
    t.string   "destination"
    t.integer  "call_timeout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.boolean  "active"
  end

  create_table "call_logs", :force => true do |t|
    t.integer  "sip_account_id"
    t.string   "source"
    t.string   "destination"
    t.string   "disposition"
    t.string   "forwarded_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "call_type"
    t.string   "source_name"
    t.string   "destination_name"
    t.string   "uuid"
  end

  create_table "call_queue_to_extensions", :force => true do |t|
    t.integer  "call_queue_id"
    t.integer  "extension_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "call_queues", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codecs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conference_to_extensions", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "extension_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.integer  "pin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "user_id"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extensions", :force => true do |t|
    t.string   "extension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "destination"
    t.boolean  "active"
  end

  create_table "fax_documents", :force => true do |t|
    t.string   "file"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "raw_file"
    t.string   "destination"
    t.datetime "received"
    t.datetime "sent"
    t.boolean  "outgoing"
    t.integer  "user_id"
  end

  create_table "global_contacts", :force => true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "phone_private"
    t.string   "phone_business"
    t.string   "phone_mobile"
    t.string   "fax_private"
    t.string   "fax_business"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location", :force => true do |t|
    t.string   "username"
    t.string   "domain"
    t.string   "contact"
    t.string   "received"
    t.string   "path"
    t.datetime "expires"
    t.float    "q"
    t.string   "callid"
    t.integer  "cseq"
    t.datetime "last_modified"
    t.integer  "flags"
    t.string   "user_agent"
    t.string   "socket"
    t.integer  "methods"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cflags"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.string   "ieee_name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_settings", :force => true do |t|
    t.string   "ip_address"
    t.string   "netmask"
    t.string   "gateway"
    t.string   "name_server"
    t.string   "dhcp_range_start"
    t.string   "dhcp_range_end"
    t.boolean  "start_dhcp_server"
    t.boolean  "dhcp_client"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interface"
  end

  create_table "nodes", :force => true do |t|
    t.string   "management_host", :limit => 64, :null => false
    t.integer  "management_port", :limit => 4
    t.string   "title",           :limit => 60, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["management_host", "management_port"], :name => "management_host_port", :unique => true
  add_index "nodes", ["title"], :name => "title", :unique => true

  create_table "ouis", :force => true do |t|
    t.string   "value"
    t.integer  "manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "phone_private"
    t.string   "phone_business"
    t.string   "phone_mobile"
    t.string   "fax_private"
    t.string   "fax_business"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_key_function_definitions", :force => true do |t|
    t.string   "name"
    t.string   "type_of_class"
    t.string   "regex_validation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_key_to_function_mappings", :force => true do |t|
    t.integer  "phone_model_key_id"
    t.integer  "phone_key_function_definition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_keys", :force => true do |t|
    t.integer  "phone_model_key_id"
    t.integer  "phone_key_function_definition_id"
    t.string   "value"
    t.string   "label"
    t.integer  "sip_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_model_codecs", :force => true do |t|
    t.integer  "phone_model_id"
    t.integer  "codec_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_model_keys", :force => true do |t|
    t.string   "name"
    t.integer  "phone_model_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_model_mac_addresses", :force => true do |t|
    t.integer  "phone_model_id"
    t.string   "starts_with"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_models", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "manufacturer_id"
    t.integer  "max_number_of_sip_accounts"
    t.integer  "number_of_keys"
    t.string   "default_http_user"
    t.string   "default_http_password"
    t.integer  "http_port"
    t.string   "reboot_request_path"
    t.boolean  "ssl"
    t.integer  "http_request_timeout"
    t.integer  "random_password_length"
    t.string   "random_password_consists_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.string   "mac_address"
    t.integer  "phone_model_id"
    t.string   "ip_address"
    t.string   "last_ip_address"
    t.string   "http_user"
    t.string   "http_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provisioning_log_entries", :force => true do |t|
    t.integer  "phone_id"
    t.string   "memo"
    t.boolean  "succeeded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pua", :force => true do |t|
    t.string   "pres_uri"
    t.string   "pres_id"
    t.integer  "event"
    t.integer  "expires"
    t.integer  "desired_expires"
    t.integer  "flag"
    t.string   "etag"
    t.string   "tuple_id"
    t.string   "watcher_uri"
    t.string   "call_id"
    t.string   "to_tag"
    t.string   "from_tag"
    t.integer  "cseq"
    t.string   "record_route"
    t.string   "contact"
    t.string   "remote_contact"
    t.integer  "version"
    t.string   "extra_headers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reboot_requests", :force => true do |t|
    t.integer  "phone_id"
    t.datetime "start"
    t.datetime "end"
    t.boolean  "successful"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_account_codecs", :force => true do |t|
    t.integer  "codec_id"
    t.integer  "sip_account_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_account_to_extensions", :force => true do |t|
    t.integer  "sip_account_id"
    t.integer  "extension_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "auth_name"
    t.string   "password"
    t.string   "realm"
    t.integer  "sip_server_id"
    t.integer  "sip_proxy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "voicemail_pin"
    t.integer  "position"
    t.integer  "voicemail_server_id"
    t.integer  "phone_id"
    t.string   "caller_name"
  end

  create_table "sip_gateways", :force => true do |t|
    t.string   "host"
    t.integer  "port"
    t.string   "realm"
    t.string   "username"
    t.string   "password"
    t.string   "from_user"
    t.string   "from_domain"
    t.boolean  "register"
    t.string   "reg_transport"
    t.integer  "expire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sip_proxies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "host"
    t.integer  "port"
    t.boolean  "is_local"
  end

  create_table "sip_servers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "host"
    t.integer  "port"
    t.boolean  "is_local"
  end

  create_table "subscriber", :force => true do |t|
    t.string   "username"
    t.string   "domain"
    t.string   "password"
    t.string   "email_address"
    t.integer  "datetime_created"
    t.integer  "datetime_modified"
    t.string   "ha1"
    t.string   "ha1b"
    t.string   "rpid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_to_extensions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "extension_id"
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
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "version", :force => true do |t|
    t.string   "table_name"
    t.integer  "table_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voicemail_servers", :force => true do |t|
    t.string   "host"
    t.integer  "port"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_local"
  end

end
