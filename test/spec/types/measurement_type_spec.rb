require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Withings::Api::MeasurementType do
  context "It Should Have Static Fields" do
    subject { Withings::Api::MeasurementType }

    # ensure expected type constants are defined
    [:WEIGHT, :HEIGHT, :FAT_MASS, :FAT_FREE_MASS, :FAT_RATIO].each do |name|
      it name do
        subject.const_get(name).should be
      end
    end

  end
end
