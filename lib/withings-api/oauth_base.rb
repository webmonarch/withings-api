require 'net/http'

module Withings::Api

  module OAuthBase
    private

    def create_consumer(consumer_key, consumer_secret)
      OAuth::Consumer.new(consumer_key, consumer_secret, {
          # todo, this needs to be parameterized
          :site => Defaults::OAUTH_BASE_URL,
          :scheme => :query_string,
          :http_method => :get,
          :signature_method => 'HMAC-SHA1',
          :request_token_path => Defaults::OAUTH_REQUEST_TOKEN_PATH,
          :authorize_path => Defaults::OAUTH_AUTHORIZE_PATH,
          :access_token_path => Defaults::OAUTH_ACCESS_TOKEN_PATH,
      })

    end

    def create_signed_request(consumer_token, access_token, parameters = {})
      default_parameters = {
          :method => :get,
          :parameters => {},
          :headers => {}
      }

      parameters = default_parameters.merge parameters

      method = parameters[:method].downcase
      path = parameters[:path]
      http_parameters = parameters[:parameters]
      http_headers = parameters[:headers]

      if method == :get && !http_parameters.empty?
        query_string = http_parameters.to_query_string

        path += "?" if ! path.include?("?")
        path += "&" if ! path.end_with? "?"

        path += query_string
      end

      consumer = create_consumer(consumer_token.key, consumer_token.secret)

      _access_token = OAuth::AccessToken.new(consumer, *access_token.to_a)
      if [:post, :put].include?(method)
        consumer.create_signed_request(method, path, _access_token, http_parameters, http_headers)
      else
        consumer.create_signed_request(method, path, _access_token, http_headers)
      end
    end

    def oauth_http_request!(consumer_token, access_token, parameters = {})
      request = create_signed_request(consumer_token, access_token, parameters)
      Net::HTTP.new("wbsapi.withings.net").request(request)
    end
  end

  # Simple wrapper class that encapsulates the results of a call to {StaticHelpers#create_request_token}
  class RequestTokenResponse
    def initialize(oauth_request_token)
      self.oauth_request_token = oauth_request_token
    end

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

    # @return [RequestToken]
    def request_token
      RequestToken.new(self.key, self.secret)
    end

    attr_accessor :oauth_request_token

    # :nodoc:
    def oauth_consumer
      self.oauth_request_token.consumer
    end
  end

  class AccessTokenResponse
    def initialize(oauth_access_token)
      @oauth_access_token = oauth_access_token
    end

    def token
      @oauth_access_token.token
    end

    alias :key :token

    def secret
      @oauth_access_token.secret
    end

    def user_id
      @oauth_access_token.params["userid"]
    end

    def access_token
      AccessToken.new(self.key, self.secret)
    end
  end

end