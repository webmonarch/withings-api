require "withings-api"
require_relative "http_stubber"

module Withings
  # A method-for-method copy of {Withings::Api} that allows
  # us to stub the HTTP responses for testing purposes (for things we
  # cannot, or don't want to hit the live Withings API for)
  module StubbeddApi
    include Withings::Api

    extend OAuthActions
    extend ApiActions

    extend self

    def stub_http(canned_response)
      stub_http_with_canned(canned_response)
    end

  end
end

CONSUMER_CREDENTIALS = {
    :valid => Withings::Api::ConsumerToken.new("08943c64c3ccfe86d5edb40c8db6ddbbc43b6f58779c77d2b02454284db7ec", "85949316f07fc41346be145fe8fbc18b73f954f280be958033571720510"),
    :invalid_secret => Withings::Api::ConsumerToken.new("08943c64c3ccfe86d5edb40c8db6ddbbc43b6f58779c77d2b02454284db7ec", "85949316f07fc41346be145fe8fbc18b73f954f280be958033571720511"),
    :blank => Withings::Api::ConsumerToken.new("", ""),
    :random => Withings::Api::ConsumerToken.new("b4d2b4445d7cbd6c344f666ccd08cd00bbfec9957e83b8887de7c7425dc23b", "0f82b1506f781059f14e034503ebef3534c37c9f75118961884b9b5f274"),
}

REQUEST_TOKENS = {
    :valid => Withings::Api::RequestToken.new("d1416462226683d9e5b77f1f4382575c0b86f257d14633d378ef26c90932", "3fef451804934cb0b93f0e1e4f7c4f074230090783899972dc640f9c1216"),
    :random => Withings::Api::RequestToken.new("92d97461313352285c5e64d6947636d6d47260beff022c112787f838bf53", "035891292e709930840cf842d437c43f1feb64c0f9f494100bf677e13c09"),
}

ACCOUNT_CREDENTIALS = {
    :test_user_1 => {:username => "withings_api_user_1@keptmetrics.com", :password => "8X4wDDanxwJ8", :user_id => 766103}
}

ACCESS_TOKENS = {
    :valid => Withings::Api::AccessToken.new("f57fc46b3b2f2dd3d88246e34c4048b0dd8d28cc3cfcfd765bff080960", "83f5563765081cc098b9cf82dd18356b915592147e3df53d33c48cbc295d45"),
}