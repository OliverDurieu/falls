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

ActiveRecord::Schema.define(version: 20151118070119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "booking_notifications", force: true do |t|
    t.string   "name"
    t.integer  "seen"
    t.integer  "user_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ride_id"
    t.integer  "booking_id"
  end

  create_table "bookings", force: true do |t|
    t.integer  "no_of_seats_booked"
    t.datetime "booking_date"
    t.integer  "user_id"
    t.integer  "ride_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "token"
    t.boolean  "payment_recieved",   default: false
  end

  create_table "car_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_makers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_models", force: true do |t|
    t.string   "name"
    t.integer  "car_maker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cars", force: true do |t|
    t.string   "car_image"
    t.string   "image_status"
    t.integer  "level_of_comfort"
    t.integer  "number_of_seats"
    t.integer  "user_id"
    t.integer  "color_id"
    t.integer  "car_model_id"
    t.integer  "car_maker_id"
    t.integer  "car_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "country_code"
    t.string   "country_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_notifications", force: true do |t|
    t.string   "name"
    t.string   "text"
    t.string   "medium"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "driver_verifications", force: true do |t|
    t.integer  "user_id"
    t.string   "email_token"
    t.boolean  "verified",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "driver_verifications", ["user_id"], name: "index_driver_verifications_on_user_id", using: :btree

  create_table "email_alerts", force: true do |t|
    t.datetime "travel_date"
    t.integer  "user_id"
    t.string   "destination"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "weekly",      default: "0"
    t.integer  "flag",        default: 0
  end

  add_index "email_alerts", ["user_id"], name: "index_email_alerts_on_user_id", using: :btree

  create_table "friends", force: true do |t|
    t.string   "name"
    t.string   "friend_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "countrycode"
    t.string   "nearbyplace"
    t.string   "phone"
    t.integer  "sequence"
    t.integer  "ride_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ride_type"
  end

  create_table "message_threads", force: true do |t|
    t.integer  "user_id"
    t.integer  "communicator_id"
    t.integer  "ride_id"
    t.integer  "status",            default: 0
    t.boolean  "unread",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_general_thread", default: false
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "message_thread_id"
    t.integer  "message_type"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "name"
    t.string   "text"
    t.string   "medium"
    t.boolean  "status",     default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", force: true do |t|
    t.string   "body"
    t.boolean  "verified_no"
    t.integer  "verification_code"
    t.integer  "public_status"
    t.integer  "user_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", force: true do |t|
    t.integer  "chattiness", default: 1
    t.integer  "music",      default: 1
    t.integer  "smoking",    default: 1
    t.integer  "pets",       default: 1
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flag",       default: 0
  end

  create_table "profiles", force: true do |t|
    t.text     "mini_bio"
    t.text     "address_1"
    t.text     "address_2"
    t.string   "displayed_as"
    t.string   "photo"
    t.string   "postcode"
    t.string   "city"
    t.integer  "country_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remote_photo"
    t.float    "longitude"
    t.float    "latitude"
  end

  create_table "ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "from_user_id"
    t.string   "user_type"
    t.integer  "star"
    t.text     "comment"
    t.integer  "driving_skill"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ride_months", force: true do |t|
    t.boolean  "jan"
    t.boolean  "feb"
    t.boolean  "mar"
    t.boolean  "apr"
    t.boolean  "may"
    t.boolean  "jun"
    t.boolean  "jul"
    t.boolean  "aug"
    t.boolean  "sep"
    t.boolean  "oct"
    t.boolean  "nov"
    t.boolean  "dec"
    t.integer  "date_type"
    t.integer  "ride_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ride_months", ["ride_id"], name: "index_ride_months_on_ride_id", using: :btree

  create_table "ride_weeks", force: true do |t|
    t.boolean  "sat"
    t.boolean  "sun"
    t.boolean  "mon"
    t.boolean  "tue"
    t.boolean  "wed"
    t.boolean  "thu"
    t.boolean  "fri"
    t.integer  "ride_id"
    t.integer  "date_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ride_weeks", ["ride_id"], name: "index_ride_weeks_on_ride_id", using: :btree

  create_table "rides", force: true do |t|
    t.text     "general_details"
    t.text     "specific_details"
    t.integer  "number_of_seats"
    t.string   "max_luggage_size"
    t.integer  "leaving_delay"
    t.integer  "detour_preferences"
    t.boolean  "is_recurring_trip"
    t.boolean  "is_details_same"
    t.boolean  "is_round_trip",       default: true
    t.datetime "departure_date"
    t.datetime "return_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "routing_required",    default: true
    t.integer  "car_id"
    t.integer  "full_completed",      default: 0
    t.string   "total_distance"
    t.string   "total_time"
    t.float    "total_price"
    t.integer  "archieve",            default: 0
    t.boolean  "review_mail_sent_to", default: false
    t.text     "event"
  end

  create_table "routes", force: true do |t|
    t.float    "price"
    t.integer  "source_id"
    t.integer  "destination_id"
    t.integer  "ride_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "arrival_time"
    t.integer  "seats",          default: 0, null: false
  end

  create_table "transections", force: true do |t|
    t.string   "t_id"
    t.string   "token"
    t.boolean  "paid"
    t.string   "status"
    t.integer  "amount"
    t.string   "currency"
    t.string   "last4"
    t.integer  "user_id"
    t.string   "ride_id"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "failure_message"
    t.integer  "booking_id"
  end

  create_table "transfer_requests", force: true do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_requests", ["booking_id"], name: "index_transfer_requests_on_booking_id", using: :btree
  add_index "transfer_requests", ["user_id"], name: "index_transfer_requests_on_user_id", using: :btree

  create_table "transfer_transactions", force: true do |t|
    t.integer  "amount"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "transfer_request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_transactions", ["transfer_request_id"], name: "index_transfer_transactions_on_transfer_request_id", using: :btree
  add_index "transfer_transactions", ["user_id"], name: "index_transfer_transactions_on_user_id", using: :btree

  create_table "transfers", force: true do |t|
    t.integer  "booking_id"
    t.string   "transfer_id"
    t.integer  "amount"
    t.string   "application_fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ride_id"
  end

  add_index "transfers", ["booking_id"], name: "index_transfers_on_booking_id", using: :btree

  create_table "unsubscribe_reasons", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unsubscribes", force: true do |t|
    t.text     "comment"
    t.boolean  "recommend"
    t.integer  "user_id"
    t.integer  "unsubscribe_reason_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "birth_year"
    t.boolean  "email_verified"
    t.boolean  "receive_updates"
    t.integer  "role"
    t.string   "total_count"
    t.boolean  "credit_status"
    t.string   "stripe_id"
    t.integer  "points",                 default: 0
    t.boolean  "verified_credentials",   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visitors", force: true do |t|
    t.integer  "user_id"
    t.integer  "ride_id"
    t.integer  "no_of_views", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visitors", ["ride_id"], name: "index_visitors_on_ride_id", using: :btree
  add_index "visitors", ["user_id"], name: "index_visitors_on_user_id", using: :btree

end
