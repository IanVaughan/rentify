require './lib/distance_calculator'
require 'json'

module Rentify
  class Property
    include DistanceCalculator
    include Enumerable

    attr_accessor :id, :name, :bedroom_count, :latitude, :longitude, :properties

    def initialize data
      @id = data[:id]
      @name = data[:name]
      @bedroom_count = data[:bedroom_count]
      @latitude = data[:latitude]
      @longitude = data[:longitude]
      @properties = @@all
    end

    def each
      @properties.each {|p| yield p}
    end

    def distances
      @distances ||= begin
        save = []
        properties.each do |other_property|
          next if self.id == other_property.id
          save << { distance: self.distance_to(other_property), to: other_property }
        end
        save
      end
    end

    # could only sort for upto distance required,
    # but would mean resorting if a larger distance was requested
    # Check: does this reorder on every call?
    def ordered #by :distance / :rooms / :price
      @ordered ||= distances.sort_by { |k| k[:distance] }
    end

    def within distance
      # if ordered, then just need to loop until first exceeded
      keep = ordered.keep_if { |p| p[:distance] < distance }
      keep.map { |p| p[:to] }
    end

    def rooms min: 0, max: 10
      properties.delete(self)
      properties.keep_if {|p| (p.bedroom_count >= min && p.bedroom_count < max) }
    end

    def to_json
      {
        id: id,
        name: name,
        bedroom_count: bedroom_count,
        latitude: latitude,
        longitude: longitude
      }.to_json
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end


    # class methods

    # should this be within the initialize?
    def self.add data
      self.all << self.new(data)
    end

    def self.each
      self.all.each { |e| yield e }
    end

    def self.all
      @@all ||= []
    end

    def self.clear
      self.all.clear
    end

    def self.find params={}
      return self.all if params == {}

      list = self.all.find_all do |p|
        params.map do |k,v|
          case v
          when String then p.send(k) =~ /#{v}/i
          when Fixnum then p.send(k) == v
          end
        end.all?
      end

      list
    end
  end
end
