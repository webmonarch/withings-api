require "withings-api/version"

require "withings-api/consts"
require "withings-api/query_string"
require "withings-api/utils"
require "withings-api/types"
require "withings-api/tokens"
require "withings-api/errors"
require "withings-api/oauth_base"
require "withings-api/oauth_actions"
require "withings-api/api_response"
require "withings-api/api_actions"

module Withings
  module Api
    extend OAuthActions
    extend ApiActions
  end
end
