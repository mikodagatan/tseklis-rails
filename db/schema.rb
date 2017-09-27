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

ActiveRecord::Schema.define(version: 20170920045224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "first_line"
    t.string "second_line"
    t.string "city_town"
    t.string "province"
    t.string "country"
    t.integer "zip_code"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean "active", default: true
    t.integer "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_leave_settings", force: :cascade do |t|
    t.integer "company_id"
    t.integer "leave_month_expiration"
    t.integer "leave_month_start"
    t.boolean "prorate_accrual"
    t.boolean "include_weekends", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "country"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employments", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.decimal "salary"
    t.boolean "inactive", default: false
    t.boolean "acceptance"
    t.integer "acceptor_id"
    t.integer "company_id"
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "endorsements", force: :cascade do |t|
    t.string "name"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "link"
    t.string "award_name"
    t.decimal "rating"
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.text "short_description"
    t.text "long_description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "landing_page_settings", force: :cascade do |t|
    t.string "photo_1_file_name"
    t.string "photo_1_content_type"
    t.integer "photo_1_file_size"
    t.datetime "photo_1_updated_at"
    t.string "photo_2_file_name"
    t.string "photo_2_content_type"
    t.integer "photo_2_file_size"
    t.datetime "photo_2_updated_at"
    t.string "photo_3_file_name"
    t.string "photo_3_content_type"
    t.integer "photo_3_file_size"
    t.datetime "photo_3_updated_at"
    t.string "photo_4_file_name"
    t.string "photo_4_content_type"
    t.integer "photo_4_file_size"
    t.datetime "photo_4_updated_at"
    t.string "video_1_file_name"
    t.string "video_1_content_type"
    t.integer "video_1_file_size"
    t.datetime "video_1_updated_at"
    t.string "video_2_file_name"
    t.string "video_2_content_type"
    t.integer "video_2_file_size"
    t.datetime "video_2_updated_at"
    t.string "video_3_file_name"
    t.string "video_3_content_type"
    t.integer "video_3_file_size"
    t.datetime "video_3_updated_at"
    t.string "video_4_file_name"
    t.string "video_4_content_type"
    t.integer "video_4_file_size"
    t.datetime "video_4_updated_at"
    t.string "call_to_action_background_file_name"
    t.string "call_to_action_background_content_type"
    t.integer "call_to_action_background_file_size"
    t.datetime "call_to_action_background_updated_at"
    t.string "header_message"
    t.string "subheader_message"
    t.text "header_description_message"
    t.string "endorsement_header"
    t.text "endorsement_description"
    t.string "testimonial_header"
    t.text "testimonial_description"
    t.string "features_header"
    t.text "features_description"
    t.string "owners_header"
    t.text "owners_description"
    t.string "contact_messages_header"
    t.text "contact_messages_description"
    t.string "plans_header"
    t.text "plans_description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_amounts", force: :cascade do |t|
    t.date "date"
    t.decimal "amount"
    t.integer "leave_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_reductions", force: :cascade do |t|
    t.date "date"
    t.decimal "amount"
    t.integer "employment_id"
    t.integer "leave_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_requests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.time "start_time"
    t.date "end_date"
    t.time "end_time"
    t.boolean "allow_weekend_holiday_leave", default: false
    t.boolean "acceptance"
    t.integer "acceptor_id"
    t.integer "leave_type_id"
    t.integer "employment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_types", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.integer "company_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.string "designation"
    t.string "quote"
    t.text "description"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean "active", default: true
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "contact_email"
    t.boolean "active", default: true
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "site_name", default: "Tseklis"
    t.text "site_description"
    t.string "site_icon_file_name"
    t.string "site_icon_content_type"
    t.integer "site_icon_file_size"
    t.datetime "site_icon_updated_at"
    t.string "site_logo_file_name"
    t.string "site_logo_content_type"
    t.integer "site_logo_file_size"
    t.datetime "site_logo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testimonials", force: :cascade do |t|
    t.string "name"
    t.string "company_name"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "video_file_name"
    t.string "video_content_type"
    t.integer "video_file_size"
    t.datetime "video_updated_at"
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_home_page_settings", force: :cascade do |t|
    t.string "create_company_photo_file_name"
    t.string "create_company_photo_content_type"
    t.integer "create_company_photo_file_size"
    t.datetime "create_company_photo_updated_at"
    t.string "connect_company_photo_file_name"
    t.string "connect_company_photo_content_type"
    t.integer "connect_company_photo_file_size"
    t.datetime "connect_company_photo_updated_at"
    t.string "company_settings_photo_file_name"
    t.string "company_settings_photo_content_type"
    t.integer "company_settings_photo_file_size"
    t.datetime "company_settings_photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "admin", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
