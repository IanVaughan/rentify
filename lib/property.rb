require './lib/distance_calculator'

module Rentify
  class Property
    include DistanceCalculator

    attr_accessor :id, :name, :bedroom_count, :latitude, :longitude

    def initialize data
      @id = data[:id]
      @name = data[:name]
      @bedroom_count = data[:bedroom_count]
      @latitude = data[:latitude]
      @longitude = data[:longitude]
    end

    # Replace with ElasticSearch
    def within distance
      list = ordered.keep_if { |p| p[:distance] < distance }
      list.map { |p| p[:to] }
    end

    def distances
      keep = []
      @@all.each do |p|
        next if self.id == p.id
        keep << { distance: self.distance_to(p), to: p }
      end
      keep
    end

    def ordered
      distances.sort_by { |k| k[:distance] }
    end


    # class methods

    # should this be within the initialize?
    def self.add data
      @@all ||= []
      @@all << self.new(data)
    end

    def self.each
      @@all ||= []
      @@all.each { |e| yield e }
    end

    def self.all
      @@all ||= []
    end

    def self.clear
      @@all.clear
    end

    def self.find params={}
      return @@all if params == {}
      @@all.find {|p| p.send(params.keys.first) == params.values.first }
    end
  end
end
