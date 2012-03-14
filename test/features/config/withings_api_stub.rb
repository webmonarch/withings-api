require 'withings-api'

module Withings
  # A method-for-method copy of {Withings::Api} that allows
  # us to stub the responses for testing purposes (for things we
  # cannot, or don't want to hit the live Withings API for)
  module StubbeddApi
    extend Withings::Api::StaticHelpers
    extend self

    def stub_http(string_or_io)
      stub_http_with(string_or_io)
    end

  end
end

CONSUMER_CREDENTIALS = {
    :valid => Withings::Api::ConsumerToken.new("08943c64c3ccfe86d5edb40c8db6ddbbc43b6f58779c77d2b02454284db7ec", "85949316f07fc41346be145fe8fbc18b73f954f280be958033571720510"),
    :blank => Withings::Api::ConsumerToken.new("", ""),
    :random => Withings::Api::ConsumerToken.new("b4d2b4445d7cbd6c344f666ccd08cd00bbfec9957e83b8887de7c7425dc23b", "0f82b1506f781059f14e034503ebef3534c37c9f75118961884b9b5f274"),
}