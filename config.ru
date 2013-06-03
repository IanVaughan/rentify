require './app/server'

require './lib/distance_calculator'
require './lib/import'
require './lib/property'

data = Rentify::Import.import('./import/data.txt')
data.each {|d| Rentify::Property.add d }

logger = Logger.new('log/app.log')
use Rack::CommonLogger, logger

run Rentify::Server
