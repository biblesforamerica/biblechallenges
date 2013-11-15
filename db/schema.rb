# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20131114151046) do

  create_table "bookfrags", :force => true do |t|
    t.string   "fragment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "book_id"
  end

  create_table "challenges", :force => true do |t|
    t.integer  "owner_id"
    t.string   "subdomain"
    t.string   "name"
    t.date     "begindate"
    t.date     "enddate"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "chapterstoread"
    t.boolean  "active",         :default => false
  end

  create_table "chapter_challenges", :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "chapter_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "chapters", :force => true do |t|
    t.string   "book_name"
    t.integer  "chapter_number"
    t.integer  "chapter_index"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "book_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "email"
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
  end

  create_table "readings", :force => true do |t|
    t.integer  "chapter_id"
    t.integer  "challenge_id"
    t.date     "date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_readings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reading_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "verses", :force => true do |t|
    t.string   "version"
    t.string   "book_name"
    t.integer  "chapter_number"
    t.integer  "verse_number"
    t.text     "versetext"
    t.integer  "book_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
