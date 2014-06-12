module Withings::Api
  class ApiResponse
    include ResultsHelpers

    attr_reader :status, :body
    alias :code :status

    def self.create!(http_response, body_class)
      raise HttpNotSuccessError.new(http_response.code, http_response.body) if http_response.code != '200'

      self.new(http_response.body, body_class)
    end

    def initialize(string_or_json, body_class)
      hash = coerce_hash string_or_json

      @status = hash["status"] || raise(InvalidFormat, :status_field_missing)

      if hash.key?("body")
        @body = body_class.new(hash["body"])
      else
        @body = body_class.new(hash)
      end
    end

    def success?
      status == 0
    end
  end
end
