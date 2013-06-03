require './app/server'

require './lib/distance_calculator'
require './lib/import'
require './lib/property'

data = Rentify::Import.import('./import/data.txt')
data.each {|d| Rentify::Property.add d }

NUMBER_TO_ADD = 100

RANDOMIZE = {
  :bedroom_count => 1..10,
  :latitude => 51.201000..51.601000,
  :longitude => 0.142000..0.542000
}

def get_add_data
  {id: "Flat #{rand(1...1000)}",
   name: "A house",
   bedroom_count: rand(RANDOMIZE[:bedroom_count]),
   latitude: rand(RANDOMIZE[:latitude]),
   longitude: rand(RANDOMIZE[:longitude])
  }
end

if true
  NUMBER_TO_ADD.times.collect { Rentify::Property.add get_add_data }
end


run Rentify::Server
