require './lib/property'
require 'spec_helper'

module Rentify
  describe Property do
    let(:property_data1) { {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000} }
    let(:property_data2) { {id: "Flat 2", name: "Trendy flat", bedroom_count: 2, latitude: 51.523778, longitude: -0.205500} }
    let(:property_data3) { {id: "Flat 3", name: "Flat with stunning view", bedroom_count: 2, latitude: 51.504444, longitude: -0.086667} }
    let(:property_data4) { {id: "Flat 4", name: "Trendy flat 2", bedroom_count: 3, latitude: 51.523708, longitude: -0.205510} }
    let(:property_data5) { {id: "Flat 6", name: "Close to A house", bedroom_count: 3, latitude: 51.501020, longitude: -0.142020} }

    describe "with no data" do
      it { Property.all.should == [] }
    end

    describe "#find" do
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
        let(:property4) { Property.new(property_data4) }
        let(:property5) { Property.new(property_data5) }

        before do
          Property.all << property1 << property2 << property3 << property4 << property5
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
          Property.find.map(&:id).should eq ["Flat 1", "Flat 2", "Flat 3", "Flat 4", "Flat 6"]
        end

        it "finds properties based on bedroom count" do
          Property.find(bedroom_count: 2).map(&:id).should eq ['Flat 2', 'Flat 3']
        end

        it "finds properties based on two fields" do
          Property.find(bedroom_count: 2, name: 'view').map(&:id).should eq ['Flat 3']
        end

        it "keeps returning" do
          Property.find(name: "Trendy flat").first.should eq property2
          Property.find(name: "Trendy flat").first.should eq property2
          Property.find(name: "Trendy flat").first.should eq property2
        end

        context "handles multiple search parameters" do
          let(:p1) { Property.find(name: 'flat').first }

          subject { Property.find(params) }

          describe "distance parameters" do
            it "returns nothing for really close" do
              Property.find(distance: 0, from: p1).should == []
            end
            context "returns nothing for really close" do
              let(:params) { {distance: 0, from: p1} }
              it { should == [] }
            end

            it "returns unsorted data" do
              Property.find(distance: 5, from: p1).map(&:id).should == ["Flat 3", "Flat 6"]
            end

            it "returns sorted data" do
              Property.find(distance: 5, from: p1, ordered: true).map(&:id).should == ["Flat 6", "Flat 3"]
            end

            it "errors if parameters wrong" do
              expect { Property.find(distance: 5) }.to raise_error FindError
              expect { Property.find(distance: nil) }.to raise_error
              expect { Property.find(distance: '') }.to raise_error FindError
              expect { Property.find(distance: []) }.to raise_error FindError

              expect { Property.find(from: p1) }.to raise_error FindError
              expect { Property.find(from: nil) }.to raise_error
              expect { Property.find(from: '') }.to raise_error FindError
              expect { Property.find(from: []) }.to raise_error FindError
            end
          end

          describe "room parameters" do
            it "returns nothing for silly search" do
              Property.find(from: p1, min_rooms: 5).should == []
            end

            it "returns unsorted data for good search" do
              Property.find(from: p1, min_rooms: 3).map(&:id).should == ["Flat 1", "Flat 4", "Flat 6"]
            end

            it "errors if parameters wrong" do
              expect { Property.find(min_rooms: nil) }.to raise_error
              expect { Property.find(min_rooms: '') }.to raise_error FindError
              expect { Property.find(min_rooms: []) }.to raise_error FindError
            end
          end

          describe "with chained finds" do
            it "returns reduced results" do
              Property.find(min_rooms: 2, from: p1).map(&:id).should == ["Flat 1", "Flat 2", "Flat 3", "Flat 4", "Flat 6"]
              p2 = Property.find(distance: 5, from: p1)
              p2.map(&:id).should == ['Flat 3', 'Flat 6']
              Property.find(min_rooms: 3, from: p2).map(&:id).should == ["Flat 6"]
            end
          end

          describe "combining parameters" do
            it "returns nothing for silly search" do
              Property.find(distance: 1, from: p1, min_rooms: 5).map(&:id).should == []
            end

            it "returns reduced results" do
              Property.find(distance: 10, from: p1, min_rooms: 3).map(&:id).should == ["Flat 4", "Flat 6"]
            end
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
    end
  end
end
