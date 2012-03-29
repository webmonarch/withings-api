require_relative '../../test/helpers/stubbed_withings_api'

# holds the API instance we are using to test with
@api = nil
@consumer_token = nil
@request_token = nil
@request_token_response, @request_token_response_exception = nil
@access_token, @access_token_exception = nil

@api_call_response, @api_call_response_exception = nil

Given /^the live Withings API$/ do
  @api = Withings::Api
end

Given /^the stubbed Withings API$/ do
  @api = Withings::StubbeddApi
end

Given /^stubbing the HTTP response with ([^\s]+)$/ do |precanned_response|
  @api.stub_http(precanned_response)
end

Given /^(a )?(valid|random|blank|invalid_secret) consumer token/ do |none, token_type|
  token_type = token_type.to_sym
  CONSUMER_CREDENTIALS.should include(token_type)

  @consumer_token = CONSUMER_CREDENTIALS[token_type]
end

Given /a valid request_token from Withings Live/ do
  step "valid consumer token"
  step "make a request_token call"
  step "request_token call should succeed"
end

Given /^authorized access request$/ do
  visit @request_token_response.authorization_url

  user = ACCOUNT_CREDENTIALS[:test_user_1]
  fill_in("email", :with => user[:username])
  fill_in("password", :with => user[:password])
  find("a.button.submit").click

  find("#accepter").click
end

Given /^(a )?(valid|random) request token$/ do |none, type|
  @request_token = REQUEST_TOKENS[type.to_sym]
end

Given /^a valid access token$/ do
  @access_token = ACCESS_TOKENS[:valid]
end

When /^(make|making) a request_token call$/ do |none|
  result_or_exception(:request_token_response) do
    @api.create_request_token(@consumer_token, "http://example.com")
  end
end

When /^(make|making) an access_token call$/ do |none|
  result_or_exception(:access_token) do
    @api.create_access_token(@request_token, @consumer_token, "666")
  end
end

When /^requesting the measure\/getmeas API$/ do
  result_or_exception(:api_call_response) do
    @api.measure_getmeas({}, @consumer_token, @access_token)
  end
end

Then /^(the )?request_token call should succeed$/ do |none|
  @request_token_response.should be
  @request_token_response.key.should =~ /\w+/
  @request_token_response.secret.should =~ /\w+/

  @request_token_response_exception.should be_nil

  @request_token = @request_token_response.request_token
end

Then /^the request_token call should fail$/ do
  @request_token_response_exception.should be

  @request_token_response.should be_nil
end

Then /^the access_token call should fail$/ do
  @access_token_exception.should be

  @access_token.should be_nil
end

Then /^the request_token (\w+) should be "(\w+)"$/ do |field, value|
  @request_token_response.send(field).should == value
end

Then /^the access_token call should succeed$/ do
  @access_token.should be

  @access_token.key.should =~ /\w+/
  @access_token.secret.should =~ /\w+/
  @access_token.user_id.should =~ /\d+/

  @access_token_exception.should be_nil
end

Then /^the measure\/getmeas call should succeed$/ do
  @api_call_response.should be
  @api_call_response_exception.should_not be
end