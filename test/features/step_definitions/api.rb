# holds the API instance we are using to test with
@api = nil
@consumer_token = nil
@request_token, @request_token_exception = nil

HTTP_STUB_RESPONSES_DIR = File.join(File.dirname(__FILE__), "../../http_stub_responses")

Given /^the live Withings API$/ do
  @api = Withings::Api
end

Given /^the stubbed Withings API$/ do
  @api = Withings::StubbeddApi
end

Given /^stubbing the HTTP response with ([^\s]+)$/ do |mock_http_response|
  file = File.new(File.join(HTTP_STUB_RESPONSES_DIR, mock_http_response + ".txt"))
  File.should exist(file)

  @api.stub_http(file.read)
end

Given /^(valid|random|blank) consumer token/ do |token_type|
  token_type = token_type.to_sym
  CONSUMER_CREDENTIALS.should include(token_type)

  @consumer_token = CONSUMER_CREDENTIALS[token_type]
end

When /^making a request_token call$/ do
  result_or_exception(:request_token) do
    @api.create_request_token(@consumer_token, "")
  end
end

Then /^the request_token call should succeed$/ do
  @request_token.should be
  @request_token.key.should =~ /\w+/
  @request_token.secret.should =~ /\w+/

  @request_token_exception.should be_nil
end

Then /^the request_token call should fail$/ do
  @request_token_exception.should be

  @request_token.should be_nil
end

Then /the request_token (\w+) should be "(\w+)"/ do |field, value|
  @request_token.send(field).should == value
end