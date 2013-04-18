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
      end
    end

    def success?
      status == 0
    end
  end
  
  class SinglyApiResponse
    include ResultsHelpers

    attr_reader :status, :body
    alias :code :status

    def self.create!(http_response, body_class)
      raise HttpNotSuccessError.new(http_response.code, http_response.body) if http_response.code != '200'

      self.new(http_response.body, body_class)
    end

    def initialize(string_or_json, body_class)
      array_of_hashes = coerce_hash string_or_json

      @status = 0

      @body = body_class.new(array_of_hashes,true)
    end

    def success?
      status == 0
    end
  end
end