require 'bundler'
ENV['RACK_ENV'] ||= 'development'

enable :logging, :dump_errors, :raise_errors

require './lib/distance_calculator'
require './lib/import'
require './lib/property'
