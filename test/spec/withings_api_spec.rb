require File.join(File.dirname(__FILE__), "spec_helper")

module Withings::Api
  describe Withings::Api do
    subject { Withings::Api }

    def stub_request_token_success
      stub_http_with_canned("request_token/success")
    end

    context "create_request_token" do
      before(:each) { stub_request_token_success }

      it "Takes Three Parameters [consumer key, consumer secret, callback URL]" do
        subject.create_request_token("key", "secret", "callback")
      end

      it "Takes Two Parameters [ConsumerToken, callback URL]" do
        subject.create_request_token(ConsumerToken.new("key", "secret"), "callback")
      end

    end

    # create an example RequestTokenResponse for subsequent tests

    def example_consumer_token
      ConsumerToken.new("key", "secret")
    end

    def example_request_token
      RequestToken.new("key", "secret")
    end

    def create_request_token_response
      stub_request_token_success
      subject.create_request_token(example_consumer_token, "callback")
    end

    def stub_access_token_success
      stub_http_with_canned("access_token/success")
    end

    context "create_access_token" do
      before(:each) { stub_access_token_success }

      it "Takes Parameters - [RequestTokenResponse, user id]" do
        request_token_response = create_request_token_response
        subject.create_access_token(request_token_response, "666")
      end

      it "Takes Parameters - [RequestToken, ConsumerToken, user id]" do
        subject.create_access_token(example_request_token, example_consumer_token, "666")
      end
    end

    #it "Can access_token With Deserialized Consumer + Request Tokens" do
    #  pending
    #
    #  api = Withings::Api
    #
    #  request_token = {:key => "", :secret => "", :consumer => {:key => "", :secret => ""}}
    #  access_token = {:key => "", :secret => "", :consumer => {:key => "", :secret => ""}}
    #
    #  api.create_access_token(request_token, "")
    #end
  end
end