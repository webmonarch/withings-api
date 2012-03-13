require File.join(File.dirname(__FILE__), "spec_helper")

MEASURE_GETMEAS_SAMPLE_HASH = JSON::parse(File.read(File.join(SAMPLE_JSON_DIR, "measure_getmeas.json")))["body"]

#
# Measurement
#

describe API::Measurement do
  #"value":79300,
  #"type":1,
  #"unit":-3
  shared_examples_for "Sample JSON Measurement" do
    it "value_raw == 79300" do
      subject.value_raw.should == 79300
    end

    it "type == MeasurementType::WEIGHT" do
      subject.measurement_type.should == API::MeasurementType::WEIGHT
    end

    it "unit == -3" do
      subject.unit.should == -3
    end

    it "value == 79.3" do
      subject.value.should == 79.3
    end
  end

  context "Measurement Sample JSON from Hash" do
    subject { API::Measurement.new(MEASURE_GETMEAS_SAMPLE_HASH["measuregrps"].first["measures"].first) }

    it_behaves_like "Sample JSON Measurement"
  end

  context "Measurement Sample JSON from String" do
    subject { API::Measurement.new(MEASURE_GETMEAS_SAMPLE_HASH["measuregrps"].first["measures"].first) }

    it_behaves_like "Sample JSON Measurement"
  end

end


describe API::MeasurementGroup do
  #"grpid":2909,
  #"attrib":0,
  #"date":1222930968,
  #"category":1,
  #"measures":[
  shared_examples_for "Sample JSON MeasurementGroup" do
    it "id == 2909" do
        subject.id.should == 2909
      end

      it "attribution == AttributionType::DEVICE" do
        subject.attribution.should == API::AttributionType::DEVICE
      end

      it "category == CategoryType::MEASURE" do
        subject.category.should == API::CategoryType::MEASURE
      end

      it "date_raw == 1222930968" do
        subject.date_raw.should == 1222930968
      end

      it "date == Time.at(1222930968)" do
        subject.date.should == Time.at(1222930968)
      end

      it "measurements == []" do
        subject.measurements.should be_instance_of Array
        subject.measurements.length.should == 4
        subject.measurements.each { |m| m.should be_instance_of API::Measurement }
      end
  end

  subject { API::MeasurementGroup.new(MEASURE_GETMEAS_SAMPLE_HASH["measuregrps"].first) }

  it_behaves_like "Sample JSON MeasurementGroup"
end

#
# MeasureGetmeasResults
#

describe API::MeasureGetmeasResults do
  shared_examples_for "Sample Measure/Getmeas Result" do
    it "update_time_raw Should Be 1249409679" do
      subject.update_time_raw.should be(1249409679)
    end

    it "update_time == Time.at(1249409679)" do
      subject.update_time.should == Time.at(1249409679)
    end

    it "more? Should Be false" do
      subject.should_not be_more
    end

    it "measure_groups" do
      measure_groups = subject.measure_groups

      measure_groups.should be_instance_of Array
      measure_groups.length.should == 2
      measure_groups.each { |mg| mg.should be_instance_of API::MeasurementGroup }
    end
  end

  context "Constructor From Sample JSON String" do
    subject { API::MeasureGetmeasResults.new(MEASURE_GETMEAS_SAMPLE_HASH.to_json) }

    it_behaves_like "Sample Measure/Getmeas Result"
  end

  context "Constructor From Sample JSON Hash" do
    subject { API::MeasureGetmeasResults.new(MEASURE_GETMEAS_SAMPLE_HASH) }

    it_behaves_like "Sample Measure/Getmeas Result"
  end

end