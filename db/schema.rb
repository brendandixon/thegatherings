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

ActiveRecord::Schema.define(version: 20160409181100) do

  create_table "attendance_records", force: :cascade do |t|
    t.integer "meeting_id",    limit: 4
    t.integer "membership_id", limit: 4
    t.boolean "attended",                default: false, null: false
  end

  add_index "attendance_records", ["id"], name: "index_attendance_records_on_id", unique: true, using: :btree
  add_index "attendance_records", ["meeting_id", "membership_id"], name: "index_gathering_member_id", unique: true, using: :btree
  add_index "attendance_records", ["meeting_id"], name: "index_attendance_records_on_meeting_id", using: :btree
  add_index "attendance_records", ["membership_id"], name: "index_attendance_records_on_membership_id", using: :btree

  create_table "campuses", force: :cascade do |t|
    t.integer  "community_id",     limit: 4,   null: false
    t.string   "name",             limit: 255
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
    t.string   "street_primary",   limit: 255
    t.string   "street_secondary", limit: 255
    t.string   "city",             limit: 255
    t.string   "state",            limit: 255
    t.string   "postal_code",      limit: 255
    t.string   "time_zone",        limit: 255
    t.string   "country",          limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "active_on"
    t.datetime "inactive_on"
  end

  add_index "campuses", ["city"], name: "index_campuses_on_city", using: :btree
  add_index "campuses", ["community_id"], name: "index_campuses_on_community_id", using: :btree
  add_index "campuses", ["id"], name: "index_campuses_on_id", unique: true, using: :btree
  add_index "campuses", ["postal_code"], name: "index_campuses_on_postal_code", using: :btree
  add_index "campuses", ["state"], name: "index_campuses_on_state", using: :btree

  create_table "communities", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "active_on",               null: false
    t.datetime "inactive_on"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "communities", ["id"], name: "index_communities_on_id", unique: true, using: :btree
  add_index "communities", ["name"], name: "index_communities_on_name", using: :btree

  create_table "gatherings", force: :cascade do |t|
    t.integer  "community_id",     limit: 4,                     null: false
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
    t.integer  "meeting_day",      limit: 4
    t.integer  "meeting_time",     limit: 4
    t.integer  "meeting_duration", limit: 4
    t.boolean  "childcare",                      default: false, null: false
    t.boolean  "childfriendly",                  default: false, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "minimum",          limit: 4
    t.integer  "maximum",          limit: 4
    t.boolean  "open",                           default: true,  null: false
    t.integer  "campus_id",        limit: 4
  end

  add_index "gatherings", ["campus_id"], name: "index_gatherings_on_campus_id", using: :btree
  add_index "gatherings", ["city"], name: "index_gatherings_on_city", using: :btree
  add_index "gatherings", ["community_id"], name: "index_gatherings_on_community_id", using: :btree
  add_index "gatherings", ["id"], name: "index_gatherings_on_id", unique: true, using: :btree
  add_index "gatherings", ["meeting_day"], name: "index_gatherings_on_meeting_day", using: :btree
  add_index "gatherings", ["meeting_time"], name: "index_gatherings_on_meeting_time", using: :btree
  add_index "gatherings", ["open"], name: "index_gatherings_on_open", using: :btree
  add_index "gatherings", ["postal_code"], name: "index_gatherings_on_postal_code", using: :btree
  add_index "gatherings", ["state"], name: "index_gatherings_on_state", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.integer  "member_id",   limit: 4,     null: false
    t.integer  "group_id",    limit: 4,     null: false
    t.string   "group_type",  limit: 255,   null: false
    t.datetime "sent_on",                   null: false
    t.text     "message",     limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "answered_on"
  end

  add_index "inquiries", ["answered_on"], name: "index_inquiries_on_answered_on", using: :btree
  add_index "inquiries", ["group_id"], name: "index_inquiries_on_group_id", using: :btree
  add_index "inquiries", ["group_type", "group_id", "member_id"], name: "index_inquiries_on_group_type_and_group_id_and_member_id", unique: true, using: :btree
  add_index "inquiries", ["group_type", "group_id"], name: "index_inquiries_on_group_type_and_group_id", using: :btree
  add_index "inquiries", ["id"], name: "index_inquiries_on_id", unique: true, using: :btree
  add_index "inquiries", ["member_id"], name: "index_inquiries_on_member_id", using: :btree

  create_table "meetings", force: :cascade do |t|
    t.integer  "gathering_id", limit: 4,                 null: false
    t.datetime "datetime",                               null: false
    t.boolean  "canceled",               default: false, null: false
  end

  add_index "meetings", ["datetime"], name: "index_meetings_on_datetime", using: :btree
  add_index "meetings", ["gathering_id", "datetime"], name: "index_gathering_datetime", unique: true, using: :btree
  add_index "meetings", ["gathering_id"], name: "index_meetings_on_gathering_id", using: :btree
  add_index "meetings", ["id"], name: "index_meetings_on_id", unique: true, using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "gender",                 limit: 25,  default: "", null: false
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
  add_index "members", ["gender"], name: "index_members_on_gender", using: :btree
  add_index "members", ["id"], name: "index_members_on_id", unique: true, using: :btree
  add_index "members", ["phone"], name: "index_members_on_phone", using: :btree
  add_index "members", ["postal_code"], name: "index_members_on_postal_code", using: :btree
  add_index "members", ["provider"], name: "index_members_on_provider", using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["uid"], name: "index_members_on_uid", using: :btree
  add_index "members", ["unlock_token"], name: "index_members_on_unlock_token", unique: true, using: :btree

  create_table "membership_requests", force: :cascade do |t|
    t.integer  "member_id",    limit: 4,     null: false
    t.integer  "gathering_id", limit: 4,     null: false
    t.datetime "sent_on",                    null: false
    t.datetime "expires_on",                 null: false
    t.text     "message",      limit: 65535
    t.datetime "responded_on"
    t.string   "status",       limit: 25
  end

  add_index "membership_requests", ["gathering_id"], name: "index_membership_requests_on_gathering_id", using: :btree
  add_index "membership_requests", ["id", "member_id", "gathering_id"], name: "index_id_member_gathering", unique: true, using: :btree
  add_index "membership_requests", ["id"], name: "index_membership_requests_on_id", unique: true, using: :btree
  add_index "membership_requests", ["member_id"], name: "index_membership_requests_on_member_id", using: :btree
  add_index "membership_requests", ["responded_on"], name: "index_membership_requests_on_responded_on", using: :btree
  add_index "membership_requests", ["status"], name: "index_membership_requests_on_status", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "member_id",   limit: 4,   null: false
    t.integer  "group_id",    limit: 4,   null: false
    t.string   "group_type",  limit: 255, null: false
    t.datetime "active_on",               null: false
    t.datetime "inactive_on"
    t.string   "participant", limit: 25
    t.string   "role",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["group_type", "group_id", "member_id"], name: "index_memberships_on_group_type_and_group_id_and_member_id", unique: true, using: :btree
  add_index "memberships", ["group_type", "group_id"], name: "index_memberships_on_group_type_and_group_id", using: :btree
  add_index "memberships", ["id"], name: "index_memberships_on_id", unique: true, using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree
  add_index "memberships", ["participant"], name: "index_memberships_on_participant", using: :btree
  add_index "memberships", ["role"], name: "index_memberships_on_role", using: :btree

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