require "withings-api/results/measure_getmeas_results"

module Withings
  module Api
    module ApiActions
      include OAuthBase

      def measure_getmeas(parameters = {}, access_token = nil, consumer_token = nil)
        consumer_token = consumer_token(consumer_token)
        access_token = access_token(access_token)

        http_response = oauth_http_request!(consumer_token, access_token, {:path => "http://wbsapi.withings.net/measure?action=getmeas", :parameters => parameters})
        Withings::Api::ApiResponse.create!(http_response, Withings::Api::MeasureGetmeasResults)
      end

      private

      def consumer_token(o)
        @consumer_token || o || raise(StandardError, "No consumer token")
      end

      def access_token(o)
        @consumer_token || o || raise(StandardError, "No access token")
      end
    end
  end
end