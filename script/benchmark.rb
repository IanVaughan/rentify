#!/usr/bin/env ruby

# Check performance of sort algorithm (its probable O(2N) or worse)

# To run:
# $ ./script/benchmark

# It checks each different method that requires a change to the dataset (see METHODS)
# And does this for different dataset sizes (see RANGES)

# I was thinking that my find/sort/search methods were not very scalable,
# but without any metrics, there was no way to prove that, or to improve on them.

require "benchmark"

require './lib/distance_calculator'
require './lib/property'

RANGES = [10, 100, 1000, 5000, 10_000]
METHODS = [:add, :find, :distances, :ordered, :within, :rooms]

# min/max range for random numbers
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

# returns the parameters required for a particular method call
# arguments_for / parameters_for ?
def data_for method
  case method
  when :add then get_add_data
  when :find then {id: 'Flat 1'}
  when :distances then nil # 10 # changing this may effect timings
  when :ordered then nil
  when :within then 10  # changing this may effect timings
  when :rooms then {min: 2}
  else raise "*** Not expecting '#{method}'"
  end
end

# Creates the correct amount of data for the test case
def setup_for method, count
  # ensure data is cleared from previous run
  Rentify::Property.clear
  case method
  when :add then nil
  when :find then count.times.collect { run(:add) }; nil
  when :distances, :ordered, :within, :rooms then count.times.collect { run(:add) }; Rentify::Property.all.first
  else raise "*** Not expecting '#{method}'"
  end
end

def run method, on = nil
  class_or_instance = (on.nil? ? Rentify::Property : on)
  parameters = data_for(method)
  parameters.nil? ? class_or_instance.send(method) : class_or_instance.send(method, parameters)
end

# Run the tests...
Benchmark.bm(17) do |x|
  METHODS.each do |method|
    RANGES.each do |count|
      on = setup_for(method, count)

      x.report("#{method} x#{count}") do
        count.times.collect { run(method, on) }
      end
    end
  end
end
