require './lib/distance_calculator'
require 'ostruct'

module Rentify
  describe DistanceCalculator do

    context "gets distance" do
      let(:pos1) { OpenStruct.new(latitude: 51.501000, longitude: -0.142000) }
      let(:pos2) { OpenStruct.new(latitude: 51.523778, longitude: -0.205500) }
      it { DistanceCalculator.distance_between(pos1, pos2).should == 5.071979719976067 }
    end

    context "gets distance to" do
      let(:pos1) { OpenStruct.new(latitude: 51.501000, longitude: -0.142000) }
      let(:pos2) { OpenStruct.new(latitude: 51.523778, longitude: -0.205500) }
      before { pos1.extend DistanceCalculator  }
      it { pos1.distance_to(pos2).should == 5.071979719976067 }
    end

  end
end
