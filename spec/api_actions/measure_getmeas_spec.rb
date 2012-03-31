require 'spec_helper'
require 'json'

describe "Withings::Api.measure_getmeas()" do
  let(:api) { Withings::Api }
  let(:valid_consumer_token) { CONSUMER_CREDENTIALS[:valid] }
  let(:valid_access_token) { ACCESS_TOKENS[:valid] }

  context "Stubbed" do
    context "Valid" do
      before(:each) do
        stub_http_with_canned("measure_getmeas/success")
        puts_http
      end

      it "Succeeds With No Parameters" do
        api.measure_getmeas(valid_consumer_token, valid_access_token, {})
      end

      it "Succeeds With userid Parameter" do
        api.measure_getmeas(valid_consumer_token, valid_access_token, {:user_id => 766103})
      end

      it "Succeeds With Parameters [:device_type, :category]" do
        parameters = {:user_id => 766103, :device_type => Withings::Api::DeviceType::BODY_SCALE, :category_type => Withings::Api::CategoryType::MEASURE}
        api.measure_getmeas(valid_consumer_token, valid_access_token, parameters)
      end

    end
  end
end

