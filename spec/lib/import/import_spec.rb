require 'spec_helper'

module Rentify
  describe Import do
    subject { described_class.import(file) }

    context 'parsing data' do
      let(:file) { %|Flat 1
"name": "A house",
"bedroom_count": 3,
"latitude": 51.501000,
"longitude": -0.142000

Flat 2
"name": "a flat",
"bedroom_count": 2,
"latitude": 51.523778,
"longitude": -0.205500
|}

      let(:expected) { [
        {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 1, longitude: 3},
        {id: "Flat 2", name: "a flat", bedroom_count: 2, latitude: 1, longitude: 3},
        ] }

      it { should eq expected }
    end

    context 'given a filename' do

    end
  end
end
