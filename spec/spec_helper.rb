# code coverage
require 'simplecov'
SimpleCov.start

require 'withings-api'

TEST_RESOURCES = File.expand_path("../test/", File.dirname(__FILE__))
SAMPLE_JSON_DIR = File.expand_path("../test/sample_json", File.dirname(__FILE__))

require_relative "../test/helpers/http_stubber"
require_relative "../test/helpers/stubbed_withings_api"

API = Withings::Api
API_MODULE = API

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