# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_12_041126) do
  create_table "cves", force: :cascade do |t|
    t.string "cve_id"
    t.string "source_identifier"
    t.datetime "published"
    t.datetime "last_modified"
    t.string "vuln_status"
    t.text "description"
    t.float "cvss_v31_base_score"
    t.float "cvss_v30_base_score"
    t.float "cvss_v2_base_score"
    t.string "weakness"
    t.string "configuration"
    t.text "reference_urls", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cve_id"], name: "index_cves_on_cve_id", unique: true
  end

end
