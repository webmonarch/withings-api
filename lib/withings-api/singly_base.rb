require 'net/https'
 
module Withings::Api

  module SinglyBase
    private

    # Executes an OAUTH signed HTTP request
    #
    # @api internal
    def singly_request!(access_token, path, parameters = {})
      uri = URI(Withings::Api::Defaults::SINGLY_API_BASE_URL + path + "?access_token="+access_token)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
     
      https.request(  Net::HTTP::Get.new(uri.request_uri) ) 
    end

  end

end