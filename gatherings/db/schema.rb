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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160110231346) do

  create_table "campuses", id: false, force: :cascade do |t|
    t.string   "id",                 limit: 36,  null: false
    t.string   "community_id",       limit: 36,  null: false
    t.string   "name",               limit: 255
    t.string   "contact_first_name", limit: 255
    t.string   "contact_last_name",  limit: 255
    t.string   "email",              limit: 255
    t.string   "phone",              limit: 255
    t.string   "street_primary",     limit: 255
    t.string   "street_secondary",   limit: 255
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.string   "postal_code",        limit: 255
    t.string   "time_zone",          limit: 255
    t.string   "country",            limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "communities", id: false, force: :cascade do |t|
    t.string   "id",          limit: 36,  null: false
    t.string   "name",        limit: 255
    t.date     "active_on"
    t.date     "inactive_on"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "gatherings", id: false, force: :cascade do |t|
    t.string   "id",               limit: 36,    null: false
    t.string   "community_id",     limit: 36,    null: false
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.string   "street_primary",   limit: 255
    t.string   "street_secondary", limit: 255
    t.string   "city",             limit: 255
    t.string   "state",            limit: 255
    t.string   "postal_code",      limit: 255
    t.string   "country",          limit: 255
    t.string   "time_zone",        limit: 255
    t.datetime "meeting_starts"
    t.datetime "meeting_ends"
    t.string   "meeting_day",      limit: 25
    t.time     "meeting_time"
    t.integer  "meeting_duration", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "members", id: false, force: :cascade do |t|
    t.string   "id",                     limit: 36,               null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "phone",                  limit: 255
    t.string   "postal_code",            limit: 25
    t.string   "country",                limit: 2
    t.string   "time_zone",              limit: 255
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "members", ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true, using: :btree
  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["first_name"], name: "index_members_on_first_name", using: :btree
  add_index "members", ["provider"], name: "index_members_on_provider", using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["uid"], name: "index_members_on_uid", using: :btree
  add_index "members", ["unlock_token"], name: "index_members_on_unlock_token", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.string   "taggable_id",   limit: 36
    t.string   "taggable_type", limit: 255
    t.string   "tagger_id",     limit: 36
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
