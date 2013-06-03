# require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require './app/server'
require 'sinatra'
require 'spec_helper'
require 'rack/test'

require './lib/distance_calculator'
require './lib/import'
require './lib/property'

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
      last_response.body.include?('home')
    end

    describe "/find" do
      context "without data" do
        it "returns correct nil" do
          get '/find', :id => 'Flat 11'
          last_response.should be_ok
          last_response.body.should == 'null'
        end
      end

      context "with data" do
        let(:data1) { {id: "Flat 11", name: "A house", bedroom_count: 3, latitude: 51.501000, longitude: -0.142000} }
        let(:data2) { {id: "Flat 12", name: "A Flat", bedroom_count: 2, latitude: 51.501000, longitude: -0.142000} }

        before do
          Property.add data1
          Property.add data2
        end

        after { Property.clear }

        it "returns first data by id" do
          get '/find', :id => 'Flat 11'
          last_response.should be_ok
          last_response.body.should == data1.to_json
        end

        it "returns last data by id" do
          get '/find', :id => 'Flat 12'
          last_response.should be_ok
          last_response.body.should == data2.to_json
        end

        it "returns last data by name" do
          get '/find', :name => 'flat'
          last_response.should be_ok
          last_response.body.should == data2.to_json
        end
      end
    end

    context "gets nearest_to" do
      before do
        mock_property = mock('Property')
        mock_property.should_receive(:first).and_return(mock_property)
        mock_property.should_receive(:within).with(20).and_return([{id: 'Flat2', lat: 1}, {id: 'Flat3', lat: 3}])
        Property.should_receive(:find).with({:id=>"Flat 1"}).and_return(mock_property)
      end

      it "works" do
        # nearest_to?id=flat 1?distance=20&bedroom=2
        get 'nearest_to', :id => 'Flat 1', :distance => 20, :bedroom_count => 2
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
