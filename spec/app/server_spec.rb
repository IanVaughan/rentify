# require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require './app/server'
require 'sinatra'
require 'spec_helper'
require 'rack/test'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

module Rentify
  describe 'Server' do
    include Rack::Test::Methods

    def app
      Server
    end

    it "gets root" do
      get '/'
      last_response.should be_ok
      last_response.body.should == 'hello' # last_response.body.include?('hello')
    end

    context "gets nearest_to" do
      before do
        mock_property = mock('Property')
        mock_property.should_receive(:within).with(20).and_return([{id: 'Flat2', lat: 1}, {id: 'Flat3', lat: 3}])
        Property.should_receive(:find).with({:id=>"Flat 1"}).and_return(mock_property)
      end

      it "works" do
        # nearest_to?id=flat 1?distance=20&bedroom=2
        get 'nearest_to', :id => 'Flat 1', :distance => 20, :min_bedroom => 2
        last_response.should be_ok
        header_content(last_response).should == 'application/json'
        last_response.body.should == [{id: 'Flat2', lat: 1}, {id: 'Flat3', lat: 3}].to_json
      end
    end
  end
end

def header_content response
  response.headers['Content-Type'].split(';')[0].strip.downcase
end
