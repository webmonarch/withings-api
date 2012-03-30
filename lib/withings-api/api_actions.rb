require "withings-api/results/measure_getmeas_results"

module Withings
  module Api

    # Contains a method corresponding to each API action provided by Withings.
    #
    # For a complete list of available API actions, see @ http://www.withings.com/en/api/wbsapiv2
    module ApiActions
      include OAuthBase

      #
      # @overload measure_getmeas(consumer_token, access_token, api_parameters, options = {})
      #   @param [ConsumerToken]
      #   @param [AccessToken]
      #   @param [Hash] api_parameters (currently, all optional)
      #   @option api_parameters [String] :user_id
      #   @param [Hash] options
      def measure_getmeas(*arguments)
        arguments = parse_arguments arguments

        consumer_token = consumer_token(arguments.delete(:consumer_token))
        access_token = access_token(arguments.delete(:access_token))
        parameters = arguments.delete(:api_parameters)

        http_response = oauth_http_request!(consumer_token, access_token, {:path => "http://wbsapi.withings.net/measure?action=getmeas", :parameters => parameters})
        Withings::Api::ApiResponse.create!(http_response, Withings::Api::MeasureGetmeasResults)
      end

      private

      def parse_arguments(args)
        parsed_args = {}

        index = 0
        args[index].kind_of?(ConsumerToken) ?
            parsed_args[:consumer_token] = args[index] : raise(ArgumentError, :consumer_token)

        index += 1
        args[index].kind_of?(AccessToken) ?
            parsed_args[:access_token] = args[index] : raise(ArgumentError, :access_token)

        index += 1
        args[index].kind_of?(Hash) ?
            parsed_args[:api_parameters] = args[index] : raise(ArgumentError, :api_parameters)

        parsed_args
      end

      def consumer_token(o)
        @consumer_token || o || raise(StandardError, "No consumer token")
      end

      def access_token(o)
        @consumer_token || o || raise(StandardError, "No access token")
      end
    end
  end
end