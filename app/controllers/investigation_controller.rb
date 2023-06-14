require 'net/http'
require 'json'
require 'dotenv/load'


class InvestigationController < ApplicationController
  def index
  end

  def show
    ip = params[:ip]
    
    # SHODAN
    api_key = ENV['SHODAN_API_KEY']
    url = "https://api.shodan.io/shodan/host/#{ip}?key=#{api_key}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    unless response.include?('Invalid IP')
      data = JSON.parse(response)
  
      @shodan_results = {
        ip: data['ip'],
        country_code: data['country_code'],
        latitude: data['latitude'],
        hostnames: hostnames = data['hostnames'][0],
        org: org = data['org'],
        asn: asn = data['asn'],
        isp: isp = data['isp'],
        ports: ports = data['ports'].join(', ')
      }
    else
      @shodan_results = { error: "Request failed with status: #{response.code}" }
    end 
    
    #VirusTotal
    api_key = ENV['VirusTotal_API_KEY']
    url = "https://www.virustotal.com/api/v3/ip_addresses/#{ip}"
    uri = URI(url)
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(uri)
    request['x-apikey'] = api_key
    
    response = http.request(request)
    if response.code == '200'
      data = JSON.parse(response.body)
      
    @virustotal_results = {
        as_owner: data["data"]["attributes"]["as_owner"],
        asn: data["data"]["attributes"]["asn"],
        country: data["data"]["attributes"]["country"],
        network: data["data"]["attributes"]["network"],
        regional_internet_registry: data["data"]["attributes"]["regional_internet_registry"],
        reputation: data["data"]["attributes"]["reputation"],
      }
    else
      @virustotal_results = { error: "Request failed with status: #{response.code}" }
    end

    
  end
end
