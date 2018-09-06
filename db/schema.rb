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

ActiveRecord::Schema.define(version: 20180910000000) do

  create_table "assigned_overseers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "membership", null: false
    t.references "gathering", null: false

    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.timestamps

    t.index ["id"], name: "index_overseers_on_id", unique: true
    t.index ["membership_id"], name: "index_overseers_on_membership"
    t.index ["gathering_id"], name: "index_overseers_on_gathering"
    t.index ["membership_id", "gathering_id"], name: "index_overseers_on_membership_and_gathering", unique: true
  end

  create_table "attendance_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "meeting", null: false
    t.references "membership", null: false

    t.boolean "attended", default: false, null: false
    t.timestamps

    t.index ["id"], name: "index_attendance_records_on_id", unique: true
    t.index ["meeting_id"], name: "index_attendance_records_on_meeting"
    t.index ["membership_id"], name: "index_attendance_records_on_membership"
    t.index ["meeting_id", "membership_id"], name: "index_attendance_records_on_meeting_and_member", unique: true
  end

  create_table "campuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: false

    t.string "name"
    t.string "street_primary"
    t.string "street_secondary"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.string "email"
    t.string "phone"
    t.boolean "primary", default: false, null: false
    t.datetime "active_on"
    t.datetime "inactive_on"
    t.timestamps

    t.index ["id"], name: "index_campuses_on_id", unique: true
    t.index ["community_id"], name: "index_campuses_on_community"
    t.index ["city"], name: "index_campus_on_city"
    t.index ["postal_code"], name: "index_campus_on_postal_code"
    t.index ["state"], name: "index_campus_on_state"
    t.index ["email"], name: "index_campus_on_email"
    t.index ["phone"], name: "index_campus_on_phone"
  end

  create_table "categories", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: true

    t.string "name"
    t.string "single"
    t.string "plural"
    t.boolean "singleton"
    t.string "prompt"
    t.string "all_prompt"
    t.timestamps

    t.index ["id"], name: "index_categories_on_id", unique: true
    t.index ["name"], name: "index_categories_on_name"
    t.index ["community_id"], name: "index_categories_on_community"
    t.index ["name", "community_id"], name: "index_categories_on_name_and_community", unique: true
  end

  create_table "communities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.timestamps

    t.index ["id"], name: "index_communities_on_id", unique: true
    t.index ["name"], name: "index_communities_on_name"
  end

  create_table "checkups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "gathering", null: false
    t.datetime "week_of", null: false

    t.integer "gather_score"
    t.integer "adopt_score"
    t.integer "shape_score"
    t.integer "reflect_score"
    t.integer "total_score"

    t.timestamps

    t.index ["id"], name: "index_checkups_on_id", unique: true
    t.index ["week_of"], name: "index_checkups_on_week_of"
    t.index ["gathering_id"], name: "index_checkups_on_gathering"
    t.index ["gathering_id", "week_of"], name: "index_checkups_on_gathering_week_of", unique: true
  end

  create_table "gatherings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: false
    t.references "campus", null: false

    t.string "name"
    t.text "description"
    t.string "street_primary"
    t.string "street_secondary"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.string "time_zone"
    t.datetime "meeting_starts"
    t.datetime "meeting_ends"
    t.integer "meeting_day"
    t.integer "meeting_time"
    t.integer "meeting_duration"
    t.integer "minimum"
    t.integer "maximum"
    t.boolean "open", default: true, null: false
    t.timestamps

    t.index ["id"], name: "index_gatherings_on_id", unique: true
    t.index ["campus_id"], name: "index_gatherings_on_campus"
    t.index ["city"], name: "index_gathering_address_on_city"
    t.index ["postal_code"], name: "index_gathering_address_on_postal_code"
    t.index ["state"], name: "index_gathering_address_on_state"
    t.index ["meeting_day"], name: "index_gatherings_on_meeting_day"
    t.index ["meeting_time"], name: "index_gatherings_on_meeting_time"
    t.index ["open"], name: "index_gatherings_on_open"
  end

  create_table "meetings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "gathering", null: false

    t.datetime "occurs", null: false
    t.boolean "canceled", default: false, null: false
    t.integer "number_present"
    t.integer "number_absent"
    t.timestamps

    t.index ["id"], name: "index_meetings_on_id", unique: true
    t.index ["occurs"], name: "index_meetings_on_occurs"
    t.index ["gathering_id"], name: "index_meetings_on_gathering"
    t.index ["gathering_id", "occurs"], name: "index_meetings_on_gathering_occurs", unique: true
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender", limit: 25, default: "", null: false
    t.string "street_primary"
    t.string "street_secondary"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.string "email"
    t.string "phone"
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
    t.string "provider"
    t.string "uid"
    t.timestamps
    
    t.index ["id"], name: "index_members_on_id", unique: true
    t.index ["first_name"], name: "index_members_on_first_name"
    t.index ["gender"], name: "index_members_on_gender"
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["city"], name: "index_members_address_on_city"
    t.index ["postal_code"], name: "index_members_address_on_postal_code"
    t.index ["state"], name: "index_members_address_on_state"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["phone"], name: "index_members_on_phone"
    t.index ["provider"], name: "index_members_on_provider"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_members_on_uid"
    t.index ["unlock_token"], name: "index_members_on_unlock_token", unique: true
    t.index ["time_zone"], name: "index_members_on_time_zone"
  end

  create_table "memberships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "member", null: false

    t.bigint "group_id", null: false, unsigned: true
    t.string "group_type", null: false
    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.string "role", null: false, limit: 25
    t.timestamps

    t.index ["id"], name: "index_memberships_on_id", unique: true
    t.index ["group_type", "group_id"], name: "index_memberships_on_group"
    t.index ["group_type", "group_id", "member_id"], name: "index_memberships_on_group_and_member", unique: true
    t.index ["member_id"], name: "index_memberships_on_member"
    t.index ["member_id", "role"], name: "index_memberships_on_member_and_role"
    t.index ["role"], name: "index_memberships_on_role"
  end

  create_table "preferences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: false
    t.references "campus"
    t.references "gathering"
    t.references "membership", null: false
    t.boolean "host"
    t.boolean "lead"
    t.timestamps
    
    t.index ["id"], name: "index_preferences_on_id", unique: true
    t.index ["campus_id"], name: "index_preferences_on_campus"
    t.index ["community_id"], name: "index_preferences_on_community"
    t.index ["community_id", "membership_id"], name: "index_preferences_on_community_and_membership", unique: true
    t.index ["gathering_id"], name: "index_preferences_on_gathering"
    t.index ["membership_id"], name: "index_preferences_on_membership"
  end

  create_table "request_owners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "membership", null: false
    t.references "request", null: false

    t.datetime "active_on", null: false
    t.datetime "inactive_on"
    t.timestamps

    t.index ["id"], name: "index_owners_on_id", unique: true
    t.index ["membership_id"], name: "index_owners_on_membership"
    t.index ["request_id"], name: "index_owners_on_request", unique: true
    t.index ["membership_id", "request_id"], name: "index_owners_on_membership_and_request", unique: true
  end

  create_table "requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: false
    t.references "campus", null: false
    t.references "membership", null: false
    t.references "gathering"

    t.datetime "sent_on", null: false
    t.datetime "expires_on", null: false
    t.text "message"
    t.datetime "responded_on"
    t.string "status", limit: 25
    t.timestamps

    t.index ["id"], name: "index_requests_on_id", unique: true
    t.index ["community_id"], name: "index_requests_on_community"
    t.index ["campus_id"], name: "index_requests_on_campus"
    t.index ["gathering_id"], name: "index_requests_on_gathering"
    t.index ["id", "membership_id", "gathering_id"], name: "index_id_membership_gathering", unique: true
    t.index ["membership_id"], name: "index_requests_on_membership"
    t.index ["responded_on"], name: "index_requests_on_responded_on"
    t.index ["status"], name: "index_requests_on_status"
  end

  create_table "role_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "community", null: false

    t.string "group_type", null: false
    t.string "role"
    t.string "name"
    t.timestamps

    t.index ["id"], name: "index_role_names_on_id", unique: true
    t.index ["community_id"], name: "index_role_names_on_community"
    t.index ["community_id", "group_type", "role"], name: "index_role_names_on_community_and_role", unique: true
    t.index ["role"], name: "index_role_names_on_role"
  end

  create_table "taggings", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "tag", null: false

    t.bigint "taggable_id", null: false, unsigned: true
    t.string "taggable_type", null: false
    t.timestamps

    t.index ["id"], name: "index_taggings_on_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tag_id", "taggable_id", "taggable_type"], name: "index_taggings_tag_and_taggable", unique: true
    t.index ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable"
  end

  create_table "tags", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.references "category", null: false

    t.string "name"
    t.string "prompt"
    t.timestamps

    t.index ["id"], name: "index_tags_on_id", unique: true
    t.index ["name"], name: "index_tags_on_name"
    t.index ["category_id"], name: "index_tags_on_category"
    t.index ["name", "category_id"], name: "index_tags_on_name_and_category", unique: true
  end

end
