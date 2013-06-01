require 'spec_helper'
require './lib/import'
require 'fakefs/spec_helpers'

module Rentify
  describe Import do
    include FakeFS::SpecHelpers

    subject { described_class.import(file) }

    let(:expected) { [
      {id: "Flat 1", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000},
      {id: "Flat 2", name: "a flat", bedroom_count: 2, latitude: 51.523778, longitude: -0.205500},
      ] }

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

      it { should eq expected }
    end

    context 'given a filename' do
      # before { FileUtils.expects(:mkdir).with("directory").once }
      # let(:file) {  }
      # it { should eq expected }
    end
  end
end
