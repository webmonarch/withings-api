require 'json'

module Withings::Api
  module ResultsHelpers
    def coerce_hash(o)
      if o.instance_of? Hash
        o
      elsif o.instance_of? String
        JSON::parse(o)
      else
        nil
      end
    end
  end



  # Class encapsulating a Measurement
  #
  # See www.withings.com/en/api/wbsapiv2
  class Measurement
    include ResultsHelpers

    attr_accessor :measurement_type, :value_raw, :unit

    def initialize(json_or_hash)
      hash = coerce_hash json_or_hash

      self.measurement_type = MeasurementType.lookup(hash["type"])
      self.value_raw = hash["value"]
      self.unit = hash["unit"]
    end

    def value
      value_raw * 10**unit
    end

  end

  # Class encapsulating a MeasurementGroup
  #
  # See www.withings.com/en/api/wbsapiv2
  class MeasurementGroup
    include ResultsHelpers

    attr_reader :id, :attribution, :date_raw, :category, :measurements;

    def initialize(json_string_or_hash)
      hash = coerce_hash json_string_or_hash

      #"grpid"=>2909, "attrib"=>0, "date"=>1222930968, "category"=>1, "measures
      @id = hash["grpid"]
      @date_raw = hash["date"]
      @attribution = AttributionType.lookup(hash["attrib"])
      @category = hash["category"]
      @measurements = []
    end

    def date
      Time.at(date_raw)
    end
  end

  # Class encapsulating the response to a call to
  # measure/getmeas
  #
  # See www.withings.com/en/api/wbsapiv2
  class MeasureGetmeasResults
    include ResultsHelpers

    attr_accessor :update_time_raw, :more, :measure_groups
    alias :more? :more

    def initialize(json_or_hash)
      hash = coerce_hash json_or_hash

      self.update_time_raw = hash["updatetime"]
      self.more = (hash["more"] == true)
      self.measure_groups = hash["measuregrps"]
    end

    def update_time
      Time.at(update_time_raw)
    end

  end
end