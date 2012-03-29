require 'oauth'

module Withings
  module Api
    module OAuth
      include ::OAuth
    end

    # Simple API to ease the OAuth setup steps for Withing API client apps.
    #
    # Specifically, this class provides methods for OAuth access token creation.
    #
    # 1. Request request tokens - via {#create_request_token}
    # 1. Redirect to authorization URL (this is handled outside of these methods, ie: by the webapp, etc.)
    # 1. Request access tokens (for permanent access to Withings content) - via {#create_access_token}
    module OAuthActions
      include OAuthBase

      Defaults = Withings::Api::Defaults

      # Issues the "request_token" oauth HTTP request to Withings.
      #
      # For call details @ Withings, see http://www.withings.com/en/api/oauthguide#access
      #
      # For details about registering your application with Withings, see http://www.withings.com/en/api/oauthguide#registration
      #
      # @param [String] consumer_token the consumer key Withings assigned on app registration
      # @param [String] consumer_secret the consumer secret Withings assigned on app registration
      # @param [String] callback_url the URL Withings should return the user to after authorization
      #
      # @return [RequestTokenResponse] something encapsulating the request response
      #
      # @raise [Timeout::Error] on connection, or read timeout
      # @raise [SystemCallError] on low level system call errors (connection timeout, connection refused)
      # @raise [ProtocolError] for HTTP 5XX error response codes
      # @raise [OAuth::Unauthorized] for HTTP 4XX error reponse codes
      # @raise [StandardError] for everything else
      def create_request_token(consumer_token, *arguments)
        _consumer_token, _consumer_secret, _callback_url = nil

        if arguments.length == 1 && consumer_token.instance_of?(Withings::Api::ConsumerToken)
          _consumer_token, _consumer_secret = consumer_token.to_a
        elsif arguments.length == 2
          _consumer_token = consumer_token
          _consumer_secret = arguments.shift
        else
          raise(ArgumentError)
        end
        _callback_url = arguments.shift

        # TODO: warn if the callback URL isn't HTTPS
        consumer = create_consumer(_consumer_token, _consumer_secret)
        oauth_request_token = consumer.get_request_token({:oauth_callback => _callback_url})

        RequestTokenResponse.new oauth_request_token
      end


      # Issues the "access_token" oauth HTTP request to Withings
      #
      # @param [RequestTokenResponse] request_token request token returned from {#create_request_token}
      # @param [String] user_id user id as returned from Withings via the {RequestTokenResponse#authorization_url}
      #
      # @return [] the shit
      def create_access_token(request_token, *arguments)
        _consumer, _request_token, _user_id = nil

        if request_token.instance_of?(RequestTokenResponse) && arguments.length == 1
          _consumer = request_token.oauth_consumer
          _request_token = request_token.oauth_request_token
          _user_id = arguments.shift
        elsif request_token.instance_of?(RequestToken) && arguments.length == 2
          request_token.instance_of?(ConsumerToken)
          _consumer = create_consumer(*arguments.shift.to_a)
          _request_token = OAuth::RequestToken.new(_consumer, *request_token.to_a)
          _user_id = arguments.shift
        else
          raise ArgumentError
        end

        oauth_access_token = _consumer.get_access_token(_request_token)

        # test for unauthorized token, since oauth + withings doesn't turn this into an explicit
        # error code / exception
        if oauth_access_token.params.key?(:"unauthorized token")
          raise StandardError, :"unauthorized token"
        end

        AccessTokenResponse.new oauth_access_token
      end

    end
  end
end
