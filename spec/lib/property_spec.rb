require './lib/property'
require 'spec_helper'

module Rentify
  describe Property do
    let(:property_data1) { {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000} }
    let(:property_data2) { {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.523778, longitude: -0.205500} }

    context "creates instance from imported data" do
      subject { Property.new(property_data1) }

      its(:name) { should eq 'A house' }
      its(:bedroom_count) { should eq 3 }
      its(:latitude) { should eq 51.501000 }
      its(:longitude) { should eq -0.142000 }
    end

    context "allows to get distance between two properties" do
      let(:property) { Property.new(property_data1) }
      let(:other_property) { Property.new(property_data2) }

      it { property.distance_to(other_property).should == 5.071979719976067 }
    end

    # context "returns checks if distance is within a given range" do
    #   let(:property) { Property.new(property_data1) }
    #   let(:other_property) { Property.new(property_data2) }

    #   it { property.within?(2).should be_false }
    #   it { property.within?(20).should be_true }
    # end
  end
end
