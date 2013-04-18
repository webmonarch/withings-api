module Withings
  module Api
    module Defaults
      API_BASE_URL = "http://wbsapi.withings.net"
      OAUTH_BASE_URL = "https://oauth.withings.com"

      OAUTH_REQUEST_TOKEN_PATH = "/account/request_token"
      OAUTH_AUTHORIZE_PATH = "/account/authorize"
      OAUTH_ACCESS_TOKEN_PATH = "/account/access_token"

      SINGLY_API_BASE_URL = "https://api.singly.com/services/withings"
    end
  end
end