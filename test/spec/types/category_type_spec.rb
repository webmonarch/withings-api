require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Withings::Api::CategoryType do
  context "It Should Have Static Fields" do
    subject { Withings::Api::CategoryType }

    # ensure expected type constants are defined
    [:MEASURE, :TARGET].each do |name|
      it name do
        subject.const_get(name).should be
      end
    end

  end
end
