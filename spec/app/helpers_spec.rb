require 'spec_helper'
require './app/helpers'

module Rentify
  describe '#helpers' do
    include Helpers

    context '#validated' do
      it { validated({id: 1, name: 2}).should eq({id: 1, name: 2}) }
      it { validated({id: 1}).should eq({id: 1}) }
      it { validated({id: 1, remove:3}).should eq({id: 1}) }
    end

  end
end
