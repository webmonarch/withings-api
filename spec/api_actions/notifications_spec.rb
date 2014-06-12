require 'spec_helper'
require 'json'

describe "Withings::Api.subscribe()" do
  let(:api) { Withings::Api }
  let(:valid_consumer_token) { CONSUMER_CREDENTIALS[:valid] }
  let(:valid_access_token) { ACCESS_TOKENS[:valid] }

  describe '#notify' do
    let(:parameters) {{ user_id: 123, callback_url: 'http://localhost', comment: 'hello user' }}
    before do
      puts_http_request
      puts_http_response
    end

    it "returns successful response from api" do
      stub_http_with_canned("notifications/notify_success")
      response = api.notify(valid_consumer_token, valid_access_token, parameters)
      expect(response).to be_successful
    end

    it "returns unsuccessful response from api" do
      stub_http_with_canned("notifications/notify_error")
      response = api.notify(valid_consumer_token, valid_access_token, parameters)
      expect(response).not_to be_successful
    end
  end
end
