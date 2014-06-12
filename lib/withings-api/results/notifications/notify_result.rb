require 'json'

module Withings::Api
  # Class encapsulating a Measurement
  #
  # See www.withings.com/en/api/wbsapiv2
  class NotifyResult
    include ResultsHelpers

    attr_reader :successful
    alias :successful? :successful

    def initialize(json_or_hash)
      hash = coerce_hash json_or_hash
      @successful = (hash["status"] == 0)
    end
  end
end

