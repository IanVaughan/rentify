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

      context "removes empty parameters" do
        it { validated({bedroom_count: ''}).should eq({}) }
      end
    end

  end
end
