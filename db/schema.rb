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

ActiveRecord::Schema.define(:version => 20130404101931) do

  create_table "action_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "action_types", ["code"], :name => "index_action_types_on_code"

  create_table "annexes", :force => true do |t|
    t.string   "name"
    t.string   "source"
    t.string   "ext"
    t.integer  "size"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "annexes", ["task_id"], :name => "index_annexes_on_task_id"

  create_table "clientely_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "address"
    t.string   "idnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "by_user_id"
  end

  create_table "duration_types", :force => true do |t|
    t.string   "code"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "efforts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "progress"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "efforts", ["task_id"], :name => "index_efforts_on_task_id"
  add_index "efforts", ["user_id"], :name => "index_efforts_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "origin_type_id"
    t.integer  "user_id"
    t.string   "target_class"
    t.boolean  "viewed"
    t.integer  "data_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action_type_id"
    t.integer  "project_id"
  end

  add_index "events", ["action_type_id"], :name => "index_events_on_action_type_id"
  add_index "events", ["origin_type_id"], :name => "index_events_on_origin_type_id"
  add_index "events", ["project_id"], :name => "index_events_on_project_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "invoice_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "number"
    t.integer  "sum_czk"
    t.integer  "invoice_type_id"
    t.integer  "project_user_relation_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "invoices", ["invoice_type_id"], :name => "index_invoices_on_invoice_type_id"
  add_index "invoices", ["project_user_relation_id"], :name => "index_invoices_on_project_user_relation_id"

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["task_id"], :name => "index_notes_on_task_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "origin_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priority_types", :force => true do |t|
    t.string   "code"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_state_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_user_relations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "relation_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hour_price_czk"
  end

  add_index "project_user_relations", ["project_id"], :name => "index_project_user_relations_on_project_id"
  add_index "project_user_relations", ["relation_type_id"], :name => "index_project_user_relations_on_relation_type_id"
  add_index "project_user_relations", ["user_id"], :name => "index_project_user_relations_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_state_type_id"
    t.datetime "work_started_at"
    t.integer  "hour_price_czk"
    t.integer  "target_price_czk"
    t.integer  "project_type_id"
  end

  add_index "projects", ["company_id"], :name => "index_projects_on_company_id"

  create_table "relation_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprints", :force => true do |t|
    t.string   "name"
    t.integer  "tier"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprints", ["project_id"], :name => "index_sprints_on_project_id"

  create_table "state_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_types", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.integer  "task_type_id"
    t.integer  "user_id"
    t.integer  "state_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assigned_user_id"
    t.integer  "duration_best_id"
    t.integer  "duration_worst_id"
    t.integer  "task_id"
    t.integer  "sprint_id"
    t.integer  "approved_by_user_id"
    t.integer  "clientely_type_id"
    t.integer  "priority_type_id"
  end

  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["sprint_id"], :name => "index_tasks_on_sprint_id"
  add_index "tasks", ["state_type_id"], :name => "index_tasks_on_state_type_id"
  add_index "tasks", ["task_type_id"], :name => "index_tasks_on_task_type_id"
  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "user_role_id"
  end

  add_index "users", ["company_id"], :name => "index_users_on_company_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
