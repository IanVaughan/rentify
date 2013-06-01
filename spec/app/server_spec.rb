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

  end
end
