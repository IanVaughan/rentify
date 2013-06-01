require 'distance_calculator'

module Rentify
  class Property
    include DistanceCalculator

    attr_accessor :name, :bedroom_count, :latitude, :longitude
    def initialize data
      @name = data[:name]
      @bedroom_count = data[:bedroom_count]
      @latitude = data[:latitude]
      @longitude = data[:longitude]
    end
  end
end
