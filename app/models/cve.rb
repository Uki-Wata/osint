class Cve < ApplicationRecord
    validates :cve_id, presence: true, uniqueness: true
    validates :source_identifier, presence: true
    validates :published, presence: true
    validates :last_modified, presence: true
    validates :vuln_status, presence: true
    validates :description, presence: true
    validates :cvss_v31_base_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    validates :cvss_v30_base_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
    validates :cvss_v2_base_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
    validates :weakness, presence: true
    validates :configuration, presence: true
    validate :valid_urls

    private
  
    def valid_urls
      return if reference_urls.all? { |url| url =~ /\A#{URI::regexp(['http', 'https'])}\z/ }
      errors.add(:reference_urls, 'contains invalid url')
    end
    
    require 'net/http'
    require 'json'
    require 'date'
    
    def self.fetch_and_format
    url = 'https://services.nvd.nist.gov/rest/json/cves/2.0/?pubStartDate=2023-06-01T00:00:00.000&pubEndDate=2023-06-12T23:59:59.999' # ここにはNVDのAPI URLを入力します
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    
    formatted_data = data['vulnerabilities'].map do |vulnerability|
      cvss_v31_base_score = vulnerability['cve']['metrics']['cvssMetricV31'][0]['cvssData']['baseScore'] rescue nil
      cvss_v30_base_score = vulnerability['cve']['metrics']['cvssMetricV30'][0]['cvssData']['baseScore'] rescue nil
      cvss_v2_base_score = vulnerability['cve']['metrics']['cvssMetricV2'][0]['cvssData']['baseScore'] rescue nil
      {
        cve_id: vulnerability['cve']['id'],
        source_identifier: vulnerability['cve']['sourceIdentifier'],
        published: vulnerability['cve']['published'],
        last_modified: vulnerability['cve']['lastModified'],
        vuln_status: vulnerability['cve']['vulnStatus'],
        description: vulnerability['cve']['descriptions'][0]['value'],
        cvss_v31_base_score: cvss_v31_base_score,
        cvss_v30_base_score: cvss_v30_base_score,
        cvss_v2_base_score: cvss_v2_base_score,
        weakness: vulnerability['cve']['weaknesses'] ? vulnerability['cve']['weaknesses'][0]['description'][0]['value'] : 'No weakness information available',
        configuration: if vulnerability['cve']['configurations'] && vulnerability['cve']['configurations'][0] && vulnerability['cve']['configurations'][0]['nodes'] && vulnerability['cve']['configurations'][0]['nodes'][0] && vulnerability['cve']['configurations'][0]['nodes'][0]['cpeMatch']
                 cpe_matches = vulnerability['cve']['configurations'][0]['nodes'][0]['cpeMatch']
                 product_names = cpe_matches.map { |cpe| cpe['criteria']&.split(":")&.fetch(3, nil) }.compact.join(", ")
                 product_names.present? ? product_names : 'No configuration information available'
               else
                 'No configuration information available'
               end,
        reference_urls: vulnerability['cve']['references'].map { |ref| ref['url'] }
      }
    end
    
    formatted_data

    end
end
