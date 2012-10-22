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

ActiveRecord::Schema.define(:version => 20120906090746) do

  create_table "activiteit", :force => true do |t|
    t.string   "omschrijving",  :limit => 15, :null => false
    t.integer  "neem_kh"
    t.integer  "neem_insuline"
    t.integer  "meet_bg"
    t.integer  "meet_ketonen"
    t.integer  "mag_extra"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "dagboek", :force => true do |t|
    t.date     "datum",                                                                                :null => false
    t.string   "tijdstip",               :limit => 5,                                                  :null => false
    t.integer  "activiteit_id"
    t.integer  "dagschema_id"
    t.integer  "glykemieschema_stap_id"
    t.string   "status",                 :limit => 1,                                 :default => "Q", :null => false
    t.integer  "aantal_kh",                                                           :default => 0
    t.integer  "hoeveelheid_ketonen",                                                 :default => 0
    t.decimal  "eenheden_insuline",                     :precision => 4, :scale => 1, :default => 0.0
    t.integer  "insuline_id"
    t.decimal  "glykemie",                              :precision => 3, :scale => 1, :default => 0.0
    t.text     "notities",               :limit => 250
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
  end

  create_table "dagschema", :force => true do |t|
    t.string   "tijdstip",                :limit => 5,                               :null => false
    t.integer  "activiteit_id"
    t.integer  "aantal_kh"
    t.decimal  "eenheden_insuline",                    :precision => 4, :scale => 1
    t.integer  "insuline_id"
    t.integer  "dagschema_geldigheid_id"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  create_table "dagschema_geldigheid", :force => true do |t|
    t.date     "start_datum"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "glykemieschema", :force => true do |t|
    t.integer  "glykemieschema_geldigheid_id"
    t.decimal  "glykemie_tot",                 :precision => 3, :scale => 1, :default => 0.0
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  create_table "glykemieschema_geldigheid", :force => true do |t|
    t.date     "start_datum"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "glykemieschema_stap", :force => true do |t|
    t.integer  "glykemieschema_id"
    t.string   "advies"
    t.integer  "wachttijd",                                                    :default => 0
    t.string   "wanneer",           :limit => 1
    t.integer  "activiteit_id"
    t.integer  "aantal_kh"
    t.decimal  "eenheden_insuline",              :precision => 4, :scale => 1
    t.integer  "insuline_id"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  create_table "insuline", :force => true do |t|
    t.string   "marktnaam",  :limit => 40, :null => false
    t.string   "afkorting",  :limit => 3,  :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

end
