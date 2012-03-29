require_relative "spec_helper"

describe "Hash#to_query_string" do
  context "Expected Results" do
    SAMPLES = {
        {} => "",
        {:name => :Eric} => "name=Eric",
        {"count" => 69 } => "count=69",
        {:first => "eric", :last => "webb", "age" => 30} => "first=eric&last=webb&age=30",
        { :special => ",./<>?=\"&" } => "special=%2C.%2F%3C%3E%3F%3D%22%26",
    }

    SAMPLES.each_key do |key|
      expect = SAMPLES[key]
      it "#{key.inspect} => \"#{expect}\"" do
        key.to_query_string.should == expect
      end
    end
  end
end