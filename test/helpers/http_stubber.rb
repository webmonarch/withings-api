require_relative "method_aliaser"

# stubs Net::HTTP with the provided response text
# @note The response parameter should be of the form of a HTTP response,
#   including status, headers, and body lines.
def stub_http_with_string(response_string)
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

HTTP_STUB_RESPONSES_DIR = File.expand_path("../http_stub_responses", File.dirname(__FILE__))

# Stubs Net::HTTP with the specified canned response text file.
# Canned responses are stored on the file system in *.txt files
#
# To stub the HTTP response with an arbitrary string, see {#stub_http_with_string}
def stub_http_with_canned(canned_response)
  file = File.new(File.join(HTTP_STUB_RESPONSES_DIR, canned_response + ".txt")) # will raise if no file
  stub_http_with_string(file.read)
end
