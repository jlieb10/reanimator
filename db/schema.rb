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

ActiveRecord::Schema.define(version: 20140813204826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "equivalencies", force: true do |t|
    t.float  "confidence"
    t.string "oclc_work_nid"
    t.string "book_nid"
    t.string "book_type"
  end

  create_table "gutenberg_books", id: false, force: true do |t|
    t.string "subtitle"
    t.string "nid"
    t.string "language"
    t.hstore "links"
    t.text   "titles",   default: [], array: true
    t.text   "authors",  default: [], array: true
  end

  add_index "gutenberg_books", ["links"], name: "index_gutenberg_books_on_links", using: :gist

  create_table "oclc_books", id: false, force: true do |t|
    t.string "nid"
    t.string "language"
    t.text   "titles",       default: [], array: true
    t.text   "descriptions", default: [], array: true
  end

  create_table "oclc_works", id: false, force: true do |t|
    t.string "nid"
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
    t.text     "construct_meta"
  end

  add_index "questions", ["task_id"], name: "index_questions_on_task_id", using: :btree

  create_table "references", force: true do |t|
    t.string   "referenced_type"
    t.string   "referenced_nid"
    t.string   "column_name"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  create_table "submissions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "option_id"
  end

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
