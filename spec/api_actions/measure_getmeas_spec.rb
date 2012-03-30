require 'spec_helper'
require 'json'

describe "Withings::Api.measure_getmeas()" do
  let(:valid_consumer_token) { CONSUMER_CREDENTIALS[:valid] }
  let(:valid_access_token) { ACCESS_TOKENS[:valid] }

  context "Stubbed" do
    context "Valid" do
      before(:each) do
        stub_http_with_canned("measure_getmeas/success")
        puts_http
      end

      it "Succeeds With No Parameters" do
        Withings::Api.measure_getmeas(valid_consumer_token, valid_access_token, {})
      end

      it "Succeeds With userid Parameter" do
        Withings::Api.measure_getmeas(valid_consumer_token, valid_access_token, {:userid => 766103})
      end

    end
  end
end

