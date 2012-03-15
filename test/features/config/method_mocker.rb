#
# ss
#

require File.join(File.dirname(__FILE__), "../../helpers/method_aliaser")
require File.join(File.dirname(__FILE__), "../../helpers/http_stubber")
require 'net/http'

def before_after_method_wrap(clazz, method_sym, &block)
  wrap = nil

  Before do
    wrap = MethodAliaser.alias_it(clazz, method_sym, &block)
  end

  After do
    wrap.unalias_it
  end
end

def print_http_req_resp
  before_after_method_wrap(Net::HTTP, :transport_request) do |aliased, *arguments|
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

#print_http_req_resp