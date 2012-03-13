module Withings
  module Api

    class TypeBase
      attr_accessor :id, :name, :description

      def initialize(id, name, description)
        self.id = id
        self.name = name
        self.description = description
      end

      def inspect
        self.description
      end

      #
      # Lookup helpers for static types
      #

      @@lookup_by_id = {}
      @@lookup_by_name = {}

      def self.register(instance)
        lookup_by_id = @@lookup_by_id[self] ||= {}
        lookup_by_name = @@lookup_by_name[self] ||= {}

        lookup_by_id[instance.id] = instance
        lookup_by_name[instance.name] = instance
      end

      def self.lookup(key)
        lookup_by_id = @@lookup_by_id[self] ||= {}
        lookup_by_name = @@lookup_by_name[self] ||= {}

        lookup_by_id[key] || lookup_by_name[key]
      end


    end

    class MeasurementType < TypeBase
    end

    class DeviceType < TypeBase
    end

    class CategoryType < TypeBase
    end

    class AttributionType < TypeBase
    end

    private

    # TODO: Try to figure out how to get calls to this documented in yard
    def self.measurement_type(name, description, id)
      instance = MeasurementType.new(id, name, description)

      MeasurementType.const_set(name, instance)
      MeasurementType.register(instance)
    end

    def self.device_type(name, description, id)
      instance = DeviceType.new(id, name, description)

      DeviceType.const_set(name, instance)
      DeviceType.register(instance)
    end

    def self.category_type(name, id, description = nil)
      instance = CategoryType.new(id, name, description)

      CategoryType.const_set(name, instance);
      CategoryType.register(instance)
    end

    def self.attribution_type(name, id, description = nil)
      instance = AttributionType.new(id, name, description)

      AttributionType.const_set(name, instance)
      AttributionType.register(instance)
    end

    public

    measurement_type :WEIGHT, "Weight (kg)", 1
    measurement_type :HEIGHT, "Height (meter)", 4
    measurement_type :FAT_FREE_MASS, "Fat Free Mass (kg)", 5
    measurement_type :FAT_RATIO, "Fat Ratio (%)", 6
    measurement_type :FAT_MASS, "Fat Mass Weight (kg)", 8
    measurement_type :DIASTOLIC_BLOOD_PRESSURE, "Diastolic Blood Pressure (mmHg)", 9
    measurement_type :SYSTOLIC_BLOOD_PRESSURE, "Systolic Blood Pressure (mmHg)", 10
    measurement_type :HEART_PULSE, "Heart Pulse (bpm)", 11

    device_type :USER, "User related", 0
    device_type :BODY_SCALE, "Body scale", 1
    device_type :BLOOD_PRESSURE_MONITOR, "Blood pressure monitor", 4

    category_type :MEASURE, 1
    category_type :TARGET, 2

    attribution_type :DEVICE, 0, "The measuregroup has been captured by a device and is known to belong to this user (and is not ambiguous)"
    attribution_type :DEVICE_AMBIGUOUS, 1, "The measuregroup has been captured by a device but may belong to other users as well as this one (it is ambiguous)"
    attribution_type :MANUAL, 2, "The measuregroup has been entered manually for this particular user"
    attribution_type :MANUAL_AT_CREATION, 4, "The measuregroup has been entered manually during user creation (and may not be accurate)"
  end
end