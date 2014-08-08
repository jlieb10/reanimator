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

ActiveRecord::Schema.define(version: 20140808150836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.text   "titles"
    t.text   "descriptions"
    t.string "subtitle"
    t.string "type"
    t.string "nid"
    t.text   "authors"
    t.text   "links"
    t.string "language"
  end

  create_table "options", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_options", force: true do |t|
    t.integer  "question_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "additional_input", default: 0
  end

  create_table "questions", force: true do |t|
    t.string   "content"
    t.integer  "expectation"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["task_id"], name: "index_questions_on_task_id", using: :btree

  create_table "submissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submissions", ["question_option_id"], name: "index_submissions_on_question_option_id", using: :btree
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string  "name"
    t.integer "category"
    t.integer "point_value", default: 0
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image_url"
    t.string   "auth_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
  end

end
