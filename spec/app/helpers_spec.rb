require 'spec_helper'
require './app/helpers'

module Rentify
  describe '#helpers' do
    include Helpers

    describe '#validated' do
      it { validated({id: 1, name: 2, bedroom_count: 3}).should eq({id: 1, name: 2, bedroom_count: 3}) }
      it { validated({bedroom_count: '3'}).should eq({bedroom_count: 3}) }
      it { validated({id: 1}).should eq({id: 1}) }
      it { validated({id: 1, remove:3}).should eq({id: 1}) }

      context "symbolise keys" do
        it { validated({'id' => 1}).should eq({id: 1}) }
      end

      # context "defaults missing parameters" do
      context "removes empty parameters" do
        it { validated({bedroom_count: ''}).should eq({}) }
      end
    end

    describe '#last_search' do
      # subject { last_search(field) }


      # let(:field) { '' }
      # let(:data) { session[:]last_search }
    end

  end
end
