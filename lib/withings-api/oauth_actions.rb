require 'oauth'

module Withings
  module Api
    module OAuth
      include ::OAuth
    end

    # Methods to ease the OAuth setup steps for using the Withings API.
    #
    # Specifically, this class provides methods for OAuth access token creation.  The steps are:
    #
    # 1. Request request tokens - via {#create_request_token}
    # 1. Redirect to authorization URL (this is handled outside of these methods, ie: by the webapp, etc.)
    # 1. Request access tokens (for permanent access to Withings content) - via {#create_access_token}
    #
    # After successfully creating an {AccessToken}, you can use the methods provided by {ApiActions} to
    # query data from Withings.
    module OAuthActions
      include OAuthBase

      Defaults = Withings::Api::Defaults

      # Issues the "request_token" oauth HTTP request to Withings.
      #
      # For the details of this process, see http://www.withings.com/en/api/oauthguide#access
      #
      # To receive the consumer credentials mentioned below, directions on registering your application with Withings is
      # @ http://www.withings.com/en/api/oauthguide#registration
      #
      # @overload create_request_token(consumer_key, consumer_secret, callback_url)
      #   @param [String] consumer_key the consumer (application) key assigned by Withings
      #   @param [String] consumer_secret the consumer (application) secret assigned by Withings
      #   @param [String] callback_url the URL Withings should use upon successful authentication and authorization by
      #     the user
      #
      # @overload create_request_token(consumer_token, callback_url)
      #   @param [ConsumerToken] conumer_token the consumer (application) token assigned by Withings
      #   @param [String] callback_url
      #
      # @return [RequestTokenResponse]
      #
      # @todo cleanup the list of exceptions raised
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


      # Issues the "access_token" oauth HTTP request to Withings.
      #
      # @note This step needs to happen AFTER successfully retrieving the request token (see {#create_request_token})
      #   and retrieving the callback from Withings signifying the user has authorized your applications access).
      #
      # @overload create_access_token(request_token, consumer_token, user_id)
      #   @param [RequestToken] request_token the request token from a previous call to {#create_request_token}}
      #   @param [ConsumerToken] consumer_token (see #create_request_token)
      #   @param [String] user_id the Withings userid (note: not currently required by Withings)
      #
      # @overload create_access_token(request_token_response, user_id)
      #   @param [RequestTokenResponse] request_token_response the result received from a previous call to {#create_request_token}
      #   @param [String] user_id the Withings userid (note: not currently required by Withings)
      #
      # @return [AccessTokenResponse]
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

    # Encapsulates the results of a call to {#create_request_token}
    class RequestTokenResponse
      # @return [String] the OAuth request token key
      def token
        self.oauth_request_token.token
      end

      alias :key :token

      # @return [String] the OAuth request token secret
      def secret
        self.oauth_request_token.secret
      end

      # @return [String] URL to redirect the user to to authorize the access to their data
      def authorization_url
        self.oauth_request_token.authorize_url
      end

      # @return [RequestToken] a RequestToken representation of
      def request_token
        RequestToken.new(self.key, self.secret)
      end


      # @private
      attr_accessor :oauth_request_token

      # @private
      def initialize(oauth_request_token)
        self.oauth_request_token = oauth_request_token
      end

      # @private
      def oauth_consumer
        self.oauth_request_token.consumer
      end
    end

    # Encapsulates the response from a call to #create_access_token
    class AccessTokenResponse
      # @private
      def initialize(oauth_access_token)
        @oauth_access_token = oauth_access_token
      end

      # @return [String] The retrieved OAuth access token key
      def token
        @oauth_access_token.token
      end

      alias :key :token

      # @return [String] The retrieved OAuth access token secret
      def secret
        @oauth_access_token.secret
      end

      # @return [String] the user_id for the user @ Withings
      def user_id
        @oauth_access_token.params["userid"]
      end

      # @return [AccessToken] an AccessToken representation of the returned key + secret pair
      def access_token
        AccessToken.new(self.key, self.secret)
      end
    end

  end
end
