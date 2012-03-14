#
# ss
#

require File.join(File.dirname(__FILE__), "../../helpers/method_aliaser")
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

# stubs Net::HTTP with the provided response text
# @note The response parameter should be of the form of a HTTP response,
#   including status, headers, and body lines.
def stub_http_with(response_string)
  wrapped = MethodAliaser.alias_it(Net::HTTP, :transport_request) do |aliased, *arguments|
    wrapped.unalias_it

    http_request = arguments.first
    socket_double = Net::BufferedIO.new(StringIO.new(response_string))

    # construct the Net::HTTPResponse
    http_response = Net::HTTPResponse.read_new(socket_double)
    http_response.reading_body(socket_double, http_request.response_body_permitted?) {
      yield http_response if block_given?
    }

    http_response
  end
end

print_http_req_resp