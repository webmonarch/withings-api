require 'withings-api'

Given /^withings\-api$/ do
  @api = Withings::Api
end

# provide either valid of invalid consumer credentials
Given /^((in)?valid) consumer credentials$/ do |type, none|
  valid = (type == "valid")

  @consumer_credentials = valid ?
      {:key => "08943c64c3ccfe86d5edb40c8db6ddbbc43b6f58779c77d2b02454284db7ec", :secret => "85949316f07fc41346be145fe8fbc18b73f954f280be958033571720510"} :
      {:key => "", :secret => ""}
end

Given /^a valid request token response$/ do
  step "withings-api"
  step "valid consumer credentials"
  step "requesting request token"
end

When /^requesting request token$/ do
  result_or_exception :request_token do
    @api.create_request_token(@consumer_credentials[:key], @consumer_credentials[:secret], 'oob')
  end
end

When /^requesting access token$/ do
  result_or_exception(:access_token) do
    @api.create_access_token(@request_token, "http://localhost:3000")
  end
end

# test the request token response

Then /^the request token request should succeed$/ do
  @request_token_exception.should be_nil
  @request_token.should be

  puts @request_token.authorization_url
end

Then /^the request token request should fail with exception( ([^ ]+))?$/ do |none, exception_name|
  @request_token.should be_nil
  @request_token_exception.should be

  if exception_name
    @request_token_exception.should be_instance_of(eval(exception_name))
  end
end

Then /^the access token request should fail with an exception$/ do
  @access_token_exception.should be
end
