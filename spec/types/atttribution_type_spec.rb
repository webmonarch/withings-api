require 'spec_helper'

describe Withings::Api::AttributionType do
  context "It Should Have Static Fields" do
    subject { Withings::Api::AttributionType }

    # ensure expected type constants are defined
    [:DEVICE, :DEVICE_AMBIGUOUS, :MANUAL, :MANUAL_AT_CREATION].each do |name|
      it name do
        subject.const_get(name).should be
      end
    end

  end
end
