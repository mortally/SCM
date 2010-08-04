# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100803173947) do

  create_table "accounts", :force => true do |t|
    t.string   "username",                                  :null => false
    t.string   "host",                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_concurrent_simulations", :default => 0, :null => false
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "game_schedulers", :force => true do |t|
    t.integer  "game_id"
    t.boolean  "active",                  :default => false, :null => false
    t.integer  "min_samples_per_profile", :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_schedulers", ["active"], :name => "index_game_schedulers_on_active"
  add_index "game_schedulers", ["game_id"], :name => "index_game_schedulers_on_game_id"

  create_table "games", :force => true do |t|
    t.integer  "server_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_strategies", :id => false, :force => true do |t|
    t.integer "strategy_id"
    t.integer "game_id"
  end

  add_index "games_strategies", ["game_id"], :name => "index_games_strategies_on_game_id"
  add_index "games_strategies", ["strategy_id"], :name => "index_games_strategies_on_strategy_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "samples", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "simulation_id"
    t.integer  "profile_id"
    t.boolean  "clean"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "samples", ["profile_id"], :name => "index_samples_on_profile_id"
  add_index "samples", ["simulation_id"], :name => "index_samples_on_simulation_id"

  create_table "servers", :force => true do |t|
    t.string   "name",         :null => false
    t.text     "description"
    t.string   "version",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "server_index"
  end

  create_table "simulations", :force => true do |t|
    t.integer  "account_id"
    t.integer  "profile_id"
    t.integer  "size",         :default => 1, :null => false
    t.string   "state"
    t.string   "job"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simulations", ["profile_id"], :name => "index_simulations_on_profile_id"

  create_table "strategies", :force => true do |t|
    t.string   "name",         :null => false
    t.text     "description"
    t.integer  "server_index", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "strategies", ["server_index"], :name => "index_strategies_on_server_index"

  create_table "three_player_adjusted_payoffs", :force => true do |t|
    t.integer  "sample_id"
    t.float    "strategy_one_payoff",     :default => 0.0, :null => false
    t.float    "strategy_two_payoff",     :default => 0.0, :null => false
    t.float    "strategy_three_payoff",   :default => 0.0, :null => false
    t.integer  "three_player_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "three_player_games_three_player_profiles", :id => false, :force => true do |t|
    t.integer "three_player_game_id"
    t.integer "three_player_profile_id"
  end

  add_index "three_player_games_three_player_profiles", ["three_player_game_id"], :name => "three_players_game_id"
  add_index "three_player_games_three_player_profiles", ["three_player_profile_id"], :name => "three_players_profile_id"

  create_table "three_player_payoffs", :force => true do |t|
    t.integer  "three_player_profile_id"
    t.float    "strategy_one_payoff",     :default => 0.0, :null => false
    t.float    "strategy_two_payoff",     :default => 0.0, :null => false
    t.float    "strategy_three_payoff",   :default => 0.0, :null => false
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "adjusted"
  end

  add_index "three_player_payoffs", ["sample_id"], :name => "index_three_player_payoffs_on_sample_id"
  add_index "three_player_payoffs", ["three_player_profile_id"], :name => "index_three_player_payoffs_on_three_player_profile_id"

  create_table "three_player_profiles", :force => true do |t|
    t.integer  "server_id"
    t.integer  "strategy_one_id"
    t.integer  "strategy_two_id"
    t.integer  "strategy_three_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
