require 'withings-api'
require File.join(File.dirname(__FILE__), "../helpers/http_stubber")
require File.expand_path("../../helpers/withings_api_stub", __FILE__)

API = Withings::Api
API_MODULE = API

SAMPLE_JSON_DIR = File.join(File.dirname(__FILE__), "..", "sample_json")

def puts_http
  MethodAliaser.alias_it(Net::HTTP, :transport_request) do |aliased, *arguments|
    puts "HTTP Request: #{arguments.first.path}"
    res = aliased.call(*arguments)
    puts "HTTP Response:"
    puts "HTTP/#{res.http_version} #{res.code} #{res.message}"
    res.to_hash.each_pair do |key, value|
      puts "#{key}: #{value.join("; ")}"
    end
    puts ""
    puts res.body

    res
  end
end