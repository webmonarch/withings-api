require 'net/http'

module Withings::Api

  module OAuthBase
    private

    # @api internal
    def create_consumer(consumer_key, consumer_secret, oauth_consumer_options = {})
      oauth_consumer_options = {
          # todo, this needs to be parameterized
          :site => Defaults::OAUTH_BASE_URL,
          :scheme => :query_string,
          :http_method => :get,
          :signature_method => 'HMAC-SHA1',
          :request_token_path => Defaults::OAUTH_REQUEST_TOKEN_PATH,
          :authorize_path => Defaults::OAUTH_AUTHORIZE_PATH,
          :access_token_path => Defaults::OAUTH_ACCESS_TOKEN_PATH,
      }.merge oauth_consumer_options

      OAuth::Consumer.new(consumer_key, consumer_secret, oauth_consumer_options)
    end

    # Executes an OAUTH signed HTTP request
    #
    # @api internal
    def api_http_request!(consumer_token, access_token, path, parameters = {})
      base_url = Withings::Api::Defaults::API_BASE_URL
      host = URI.parse(base_url).host

      parameters = parameters.merge(:path => path, :oauth_options => {:site => base_url})

      request = create_signed_request(consumer_token, access_token, parameters)
      Net::HTTP.new(host).request(request)
    end

    # Creates a signed Net::HTTP::HTTPRequest with the specified parameters
    #
    # @api internal
    def create_signed_request(consumer_token, access_token, parameters = {})
      default_parameters = {
          :method => :get,
          :parameters => {},
          :headers => {},
          :oauth_options => {}
      }

      parameters = default_parameters.merge parameters

      method = parameters[:method].downcase
      path = parameters[:path]
      http_parameters = parameters[:parameters]
      http_headers = parameters[:headers]
      oauth_options = parameters[:oauth_options]

      if method == :get && !http_parameters.empty?
        query_string = http_parameters.to_query_string

        path += "?" if ! path.include?("?")
        path += "&" if ! path.end_with? "?"

        path += query_string
      end

      consumer = create_consumer(consumer_token.key, consumer_token.secret, oauth_options)

      _access_token = OAuth::AccessToken.new(consumer, *access_token.to_a)
      if [:post, :put].include?(method)
        consumer.create_signed_request(method, path, _access_token, http_parameters, oauth_options, http_headers)
      else
        consumer.create_signed_request(method, path, _access_token, oauth_options, http_headers)
      end
    end

  end

end