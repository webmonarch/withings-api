require File.join(File.dirname(__FILE__), "..", "spec_helper")
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
        api_response = Withings::Api.measure_getmeas({:userid => 766103}, valid_access_token, valid_consumer_token)
      end

    end
  end
end

