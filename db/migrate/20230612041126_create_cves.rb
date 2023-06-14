class CreateCves < ActiveRecord::Migration[7.0]
  def change
    create_table :cves do |t|
      t.string :cve_id
      t.string :source_identifier
      t.datetime :published
      t.datetime :last_modified
      t.string :vuln_status
      t.text :description
      t.float :cvss_v31_base_score
      t.float :cvss_v30_base_score
      t.float :cvss_v2_base_score
      t.string :weakness
      t.string :configuration
      t.text :reference_urls,default: ""
      t.timestamps
    end
    add_index :cves, :cve_id, unique: true
  end
end
