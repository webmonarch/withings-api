require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Withings::Api::DeviceType do
  context "It Should Have Static Fields" do
    subject { Withings::Api::DeviceType }

    # ensure expected type constants are defined
    [:USER, :BODY_SCALE, :BLOOD_PRESSURE_MONITOR].each do |name|
      it name do
        subject.const_get(name).should be
      end
    end

  end
end
