require './lib/property'
require 'spec_helper'

module Rentify
  describe Property do
    let(:property_data1) { {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000} }
    let(:property_data2) { {id: "Flat 2", name: "Trendy flat", bedroom_count: 2, latitude: 51.523778, longitude: -0.205500} }
    let(:property_data3) { {id: "Flat 3", name: "Flat with stunning view", bedroom_count: 2, latitude: 51.504444, longitude: -0.086667} }

    context "behaves like active record" do
      describe "with no data" do
        it { Property.first.should == nil }
        it { Property.all.should == [] }
      end

      describe "with added data" do
        before { Property.add(property_data1) }

        it { Property.first.should be_an_instance_of Property }
        it { Property.first.id.should == Property.new(property_data1).id }
      end
    end

    context "creates instance from imported data" do
      subject { Property.new(property_data1) }

      its(:id) { should eq 'Flat 1' }
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

    describe "sorting" do
      # Should this be "saving" them in its local collection as well
      let(:property1) { Property.new(property_data1) }
      let(:property2) { Property.new(property_data2) }
      let(:property3) { Property.new(property_data3) }
      before do
        Property.all << property1 << property2 << property3
      end

      after { Property.clear }

      it "creates a hash of distances to each other property" do
        expected = [
          {:distance=>5.071979719976067, :to=>property2},
          {:distance=>3.849045551582071, :to=>property3}
        ]
        property1.distances.should eq expected
      end

      it "orders properties by distance" do
        expected = [
          {:distance=>3.849045551582071, :to=>property3},
          {:distance=>5.071979719976067, :to=>property2}
        ]
        property1.ordered.should == expected
      end

      context "returns properties within a given distance range" do
        it "returns nothing for something really close" do
          property1.within(2).should == []
        end
        it { property1.within(4.0).should == [property3] }
        it { property1.within(10).should == [property3, property2] }
      end
    end
  end
end
