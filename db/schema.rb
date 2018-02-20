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

ActiveRecord::Schema.define(version: 20180208205758) do

  create_table "attendance_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "meeting_id"
    t.integer "membership_id"
    t.boolean "attended", default: false, null: false
    t.index ["id"], name: "index_attendance_records_on_id", unique: true
    t.index ["meeting_id", "membership_id"], name: "index_gathering_member_id", unique: true
    t.index ["meeting_id"], name: "index_attendance_records_on_meeting_id"
    t.index ["membership_id"], name: "index_attendance_records_on_membership_id"
  end

  create_table "campuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "community_id", null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "street_primary"
    t.string "street_secondary"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "time_zone"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "active_on"
    t.datetime "inactive_on"
    t.index ["city"], name: "index_campuses_on_city"
    t.index ["community_id"], name: "index_campuses_on_community_id"
    t.index ["id"], name: "index_campuses_on_id", unique: true
    t.index ["postal_code"], name: "index_campuses_on_postal_code"
    t.index ["state"], name: "index_campuses_on_state"
  end

  create_table "communities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_communities_on_id", unique: true
    t.index ["name"], name: "index_communities_on_name"
  end

  create_table "gatherings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "community_id", null: false
    t.string "name"
    t.text "description"
    t.string "street_primary"
    t.string "street_secondary"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "time_zone"
    t.datetime "meeting_starts"
    t.datetime "meeting_ends"
    t.integer "meeting_day"
    t.integer "meeting_time"
    t.integer "meeting_duration"
    t.boolean "childcare", default: false, null: false
    t.boolean "childfriendly", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minimum"
    t.integer "maximum"
    t.boolean "open", default: true, null: false
    t.integer "campus_id"
    t.index ["campus_id"], name: "index_gatherings_on_campus_id"
    t.index ["city"], name: "index_gatherings_on_city"
    t.index ["community_id"], name: "index_gatherings_on_community_id"
    t.index ["id"], name: "index_gatherings_on_id", unique: true
    t.index ["meeting_day"], name: "index_gatherings_on_meeting_day"
    t.index ["meeting_time"], name: "index_gatherings_on_meeting_time"
    t.index ["open"], name: "index_gatherings_on_open"
    t.index ["postal_code"], name: "index_gatherings_on_postal_code"
    t.index ["state"], name: "index_gatherings_on_state"
  end

  create_table "inquiries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "member_id", null: false
    t.integer "group_id", null: false
    t.string "group_type", null: false
    t.datetime "sent_on", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "answered_on"
    t.index ["answered_on"], name: "index_inquiries_on_answered_on"
    t.index ["group_id"], name: "index_inquiries_on_group_id"
    t.index ["group_type", "group_id", "member_id"], name: "index_inquiries_on_group_type_and_group_id_and_member_id", unique: true
    t.index ["group_type", "group_id"], name: "index_inquiries_on_group_type_and_group_id"
    t.index ["id"], name: "index_inquiries_on_id", unique: true
    t.index ["member_id"], name: "index_inquiries_on_member_id"
  end

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "gathering_id", null: false
    t.datetime "datetime", null: false
    t.boolean "canceled", default: false, null: false
    t.index ["datetime"], name: "index_meetings_on_datetime"
    t.index ["gathering_id", "datetime"], name: "index_gathering_datetime", unique: true
    t.index ["gathering_id"], name: "index_meetings_on_gathering_id"
    t.index ["id"], name: "index_meetings_on_id", unique: true
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender", limit: 25, default: "", null: false
    t.string "email", default: "", null: false
    t.string "phone"
    t.string "postal_code", limit: 25
    t.string "country", limit: 2
    t.string "time_zone"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["first_name"], name: "index_members_on_first_name"
    t.index ["gender"], name: "index_members_on_gender"
    t.index ["id"], name: "index_members_on_id", unique: true
    t.index ["phone"], name: "index_members_on_phone"
    t.index ["postal_code"], name: "index_members_on_postal_code"
    t.index ["provider"], name: "index_members_on_provider"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_members_on_uid"
    t.index ["unlock_token"], name: "index_members_on_unlock_token", unique: true
  end

  create_table "membership_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "member_id", null: false
    t.integer "gathering_id", null: false
    t.datetime "sent_on", null: false
    t.datetime "expires_on", null: false
    t.text "message"
    t.datetime "responded_on"
    t.string "status", limit: 25
    t.index ["gathering_id"], name: "index_membership_requests_on_gathering_id"
    t.index ["id", "member_id", "gathering_id"], name: "index_id_member_gathering", unique: true
    t.index ["id"], name: "index_membership_requests_on_id", unique: true
    t.index ["member_id"], name: "index_membership_requests_on_member_id"
    t.index ["responded_on"], name: "index_membership_requests_on_responded_on"
    t.index ["status"], name: "index_membership_requests_on_status"
  end

  create_table "memberships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "member_id", null: false
    t.integer "group_id", null: false
    t.string "group_type", null: false
    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.string "participant", limit: 25
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["group_type", "group_id", "member_id"], name: "index_memberships_on_group_type_and_group_id_and_member_id", unique: true
    t.index ["group_type", "group_id"], name: "index_memberships_on_group_type_and_group_id"
    t.index ["id"], name: "index_memberships_on_id", unique: true
    t.index ["member_id"], name: "index_memberships_on_member_id"
    t.index ["participant"], name: "index_memberships_on_participant"
    t.index ["role"], name: "index_memberships_on_role"
  end

  create_table "taggings", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["id"], name: "id", unique: true
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["id"], name: "id", unique: true
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

end
