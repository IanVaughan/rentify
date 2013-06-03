require 'bundler'
ENV['RACK_ENV'] ||= 'development'

enable :logging, :dump_errors, :raise_errors

# Only redirect the output to a log if it's non development
unless Sinatra::Base.environment == :development
  log = File.new("./log/#{Sinatra::Base.environment}.log", "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end
require './lib/distance_calculator'
require './lib/import'
require './lib/property'
