require './lib/property'
require 'spec_helper'

module Rentify
  describe Property do
    let(:property_data1) { {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000} }
    let(:property_data2) { {id: "Flat 2", name: "Trendy flat", bedroom_count: 2, latitude: 51.523778, longitude: -0.205500} }
    let(:property_data3) { {id: "Flat 3", name: "Flat with stunning view", bedroom_count: 2, latitude: 51.504444, longitude: -0.086667} }
    let(:property_data4) { {id: "Flat 4", name: "Trendy flat 2", bedroom_count: 3, latitude: 51.523708, longitude: -0.205510} }

    context "behaves like active record" do
      describe "with no data" do
        it { Property.all.should == [] }
      end

      describe "with added data" do
        before { Property.add(property_data1) }

        context "with no data" do
          it { Property.find(id: 1).first.should be_nil }
          it { Property.find(id: 1).count.should == 0 }
          it { Property.find(id: '').first.should be_nil }
          it { Property.find(id: 'Flat 1').first.should be_nil }
        end

        context "with data" do
          let(:property1) { Property.new(property_data1) }
          let(:property2) { Property.new(property_data2) }
          let(:property3) { Property.new(property_data3) }

          before do
            Property.all << property1 << property2 << property3
          end

          after { Property.clear }

          it "returns an Array of Properties for objects found" do
            prop = Property.find(name: "Trendy flat")
            prop.should be_an_instance_of Array
            prop.first.should be_an_instance_of Property
            prop.first.name.should == "Trendy flat"
            prop.first.to_json.should == property_data2.to_json
          end

          it "should be case insensitive" do
            Property.find(name: "tRendy").first.to_json.should == property_data2.to_json
          end

          it "returns an empty array when no match found on id" do
            Property.find(id: 10).first.should be_nil
          end

          it "returns 1 match when searched on a unique id" do
            Property.find(id: 'Flat 1').count.should eq 1
            Property.find(id: 'Flat 1').first.should eq property1
          end

          it "returns 1 match when searched on a unique name" do
            Property.find(name: "Trendy flat").first.should eq property2
          end

          it "returns all properties when no search criteria given" do
            Property.find().should eq [property1, property2, property3]
          end

          # This only "meets" the requirement of finding "more than 2 bedrooms"
          # But it would make sense to add min/max bed count
          it "finds properties based on bedroom count" do
            Property.find(bedroom_count: 2).map(&:id).should eq ['Flat 2', 'Flat 3']
          end

          it "finds properties based on two fields" do
            Property.find(bedroom_count: 2, name: 'view').map(&:id).should eq ['Flat 3']
          end
        end
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
      let(:property4) { Property.new(property_data4) }

      before do
        Property.all << property1 << property2 << property3
      end

      after { Property.clear }

      describe "#distances" do
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
      end

      describe "#within" do # : returns properties within a given distance range" do
        context "its return type" do
          subject { property1.within(10.0) }
          it { should be_an_instance_of Array }
          its(:first) { should be_an_instance_of Property }
        end

        context "returns nothing when no results match" do
          subject { property1.within(1) }
          it { should be_an_instance_of Array }
          it { should == [] }
          its(:first) { should be_nil }
          its(:count) { should == 0 }
        end

        context "returns data when found" do
          subject { property1.within(4.1) }

          it { should be_an_instance_of Array }
          it { should eq [property3] }
          its(:first) { should == property3 }
          its(:count) { should == 1 }

          it { property1.within(4.1).map(&:id).should == ["Flat 3"] }
          it { property1.within(4).map(&:id).should == ["Flat 3"] }
          it { property1.within(10).map(&:id).should == ["Flat 3", "Flat 2"] }
        end
      end

      describe "#rooms" do # : finds properties with same number or more rooms" do
        context "its return type" do
          subject { property1.rooms }
          it { should be_an_instance_of Array }
          its(:first) { should be_an_instance_of Property }
        end

        it "has Properties within the Array" do
          property1.rooms.first.should be_an_instance_of Property
        end

        it "returns nothing when properties do not find a match" do
          property1.rooms(min: 10).count.should == 0
        end

        it "returns matching when properties match" do
          property1.rooms(min: 2).map(&:id).should == ["Flat 3", "Flat 2"]
        end

        it "can be called again" do
          property1.rooms(min: 2).map(&:id).should == ["Flat 3", "Flat 2"]
          property1.rooms(min: 2).map(&:id).should == ["Flat 3", "Flat 2"]
        end
      end

      describe "method call order" do
        it "doesn't mater which order methods are called" do
          room_first = [property1.rooms, property1.within(10)]
          within_first = [property1.within(10), property1.rooms]
          room_first.should == within_first.reverse
        end

        context "chains searches" do
          before { Property.all << property4 }
          subject { property4 }
          its(:count) { should == 4 }

          describe "narrow search results" do
            let(:subset) { subject.within(1) }

            it "has not altered the original dataset" do
              subject.count.should == 4
            end

            it "has returned a subset" do
              subset.count.should == 1
            end
          end

          describe "narrow search results does not include itself" do
            let(:subset) { subject.within(1000) }

            it "has returned a subset of other properties" do
              subset.count.should == 3
              subset.map(&:id).should_not include("Flat 4")
            end
          end

          describe "narrow search results by two types" do
            before do
              @subset1 = subject.within(6)
              @subset2 = subject.rooms(min: 3)
            end

            it "has altered the original dataset and returned a subset" do
              subject.id.should == "Flat 4"
              subject.count.should == 4

              @subset1.count.should == 2
              @subset1.map(&:id).should == ["Flat 2", "Flat 1"]

              @subset2.count.should == 1
              @subset2.map(&:id).should == ["Flat 1"]
            end
          end

          describe "narrow search results by two types in different order" do
            before do
              @subset2 = subject.rooms(min: 3)
              @subset1 = subject.within(6)
            end

            it "has altered the original dataset and returned a subset" do
              subject.id.should == "Flat 4"
              subject.count.should == 4

              @subset1.count.should == 1
              @subset1.map(&:id).should == ["Flat 1"]

              @subset2.count.should == 1
              @subset2.map(&:id).should == ["Flat 1"]
            end
          end

          describe "narrow search results by two types in different order 2" do
            before do
              @subset2 = subject.rooms(min: 2)
              @subset1 = subject.within(6)
            end

            it "has altered the original dataset and returned a subset" do
              subject.id.should == "Flat 4"
              subject.count.should == 4

              @subset1.count.should == 2
              @subset1.map(&:id).should == ["Flat 2", "Flat 1"]

              @subset2.count.should == 3
              @subset2.map(&:id).should == ["Flat 2", "Flat 1", "Flat 3"]
            end
          end
        end
      end
    end
  end
end
