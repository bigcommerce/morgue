require 'rubygems'
require 'json'
require 'net/http'
require 'open-uri'

def query_puppetdb(endpoint, stage, query)

  if query.empty? or endpoint.empty? or stage.empty?
    puts 'You need to configure a query to run against puppetdb'
    exit 1
  end

  options = { :puppetdb_host => "puppet.bigcommerce.net",
              :puppetdb_port => "80" }

  http = Net::HTTP.new(options[:puppetdb_host], options[:puppetdb_port])

  headers = {
    "Accept" => "application/json",
    "Host"   => "puppet.bigcommerce.net"
  }

  uri = "/query/#{endpoint}/#{stage}/#{query}"

  begin
    resp = http.get(uri, headers)
    return JSON(resp.body)
  rescue Exception => e
    puts e
  end

end