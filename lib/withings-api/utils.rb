module Withings::Api
  module ResultsHelpers
    # @raise [JSON::ParserError]
    def coerce_hash(o)
      if o.instance_of? Hash
        o
      elsif o.instance_of? Array
        o
      elsif o.instance_of? String
        JSON::parse(o)
      else
        nil
      end
    end
  end
end