require File.join(File.dirname(__FILE__), "spec_helper")

shared_examples_for "Token" do
  context "Constructor" do
    it "Default" do
      subject.class.new
    end

    it "Key + Secret" do
      subject.class.new("", "")
    end
  end

  context "Methods" do
    it "#key getter" do
      subject.should respond_to :key
    end

    it "#secret getter" do
      subject.should respond_to :secret
    end
  end
end

describe Withings::Api::ConsumerToken do
  it_behaves_like "Token"

end

describe Withings::Api::RequestToken do
  it_behaves_like "Token"

end

describe Withings::Api::AccessToken do
  it_behaves_like "Token"

end