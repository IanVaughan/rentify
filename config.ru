require './app/server'

require './lib/distance_calculator'
require './lib/import'
require './lib/property'

data = Rentify::Import.import('./import/data.txt')
data.each {|d| Rentify::Property.add d }

run Rentify::Server
