require './lib/distance_calculator'
require 'ostruct'

module Rentify
  describe DistanceCalculator do

    context "gets distance" do
      # subject { described_class.distance_between(pos1, pos2) }
      let(:pos1) { OpenStruct.new(latitude: 51.501000, longitude: -0.142000) }
      let(:pos2) { OpenStruct.new(latitude: 51.523778, longitude: -0.205500) }
      # it { should == 5.071979719976067 }
      it { DistanceCalculator.distance_between(pos1, pos2).should == 5.071979719976067 }
    end

    context "gets distance to" do
      let(:pos1) { OpenStruct.new(latitude: 51.501000, longitude: -0.142000) }
      let(:pos2) { OpenStruct.new(latitude: 51.523778, longitude: -0.205500) }
      before { pos1.extend DistanceCalculator  }
      it { pos1.distance_to(pos2).should == 5.071979719976067 }
    end



    # context "allows sorting" do
    #   let(:properties) { [property_data1, property_data2, property_data3] }
    #   before { properties extend DistanceCalculator }
    #   it { properties.sort.should == [property_data1, property_data3, property_data2] }
    # end

    # context "returns properties within a given distance range" do
    #   let(:property1) { Property.new(property_data1) }
    #   let(:property2) { Property.new(property_data2) }
    #   let(:property2) { Property.new(property_data2) }

    #   it { property1.find_within(2).should == [] }
    #   it { property1.find_within(20).should == [property2] }
    #   it { property1.find_within(20).should == [property2, property3] }
    # end

  end
end
