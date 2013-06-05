require './lib/distance_calculator'
require 'json'

module Rentify
  class FindError < ArgumentError; end

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
      properties.each {|p| yield p}
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
    # private :distances

    # could only sort for upto distance required,
    # but would mean resorting if a larger distance was requested
    # Check: does this reorder on every call?
    def ordered #by :distance / :rooms / :price
      @ordered ||= distances.sort_by { |k| k[:distance] }
    end
    # private :ordered

    def within distance, sorted = true
      # if ordered, then just need to loop until first exceeded
      dataset = sorted ? ordered : distances
      keep = dataset.select { |p| p[:distance] < distance }
      keep.map { |p| p[:to] }
    end

    def rooms dataset: properties, min: 0, max: 10
      raise FindError unless min.is_a?(Fixnum) && max.is_a?(Fixnum)
      # keep = ordered
      # keep.delete(self)
      dataset.select {|p| (p.bedroom_count >= min && p.bedroom_count < max) }
      # keep = ordered.keep_if { |p| (p[:to].bedroom_count >= min && p[:to].bedroom_count < max) }
      # keep.map { |p| p[:to] }
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

    # Class methods
    class << self

      # should this be within the initialize?
      def add data
        self.all << self.new(data)
      end

      def each
        self.all.each { |e| yield e }
      end

      def all
        @@all ||= []
      end

      def clear
        self.all.clear
      end

      # mega overloaded function! needs to be broken down
      def find params={}
        return self.all if params.empty?

        dataset = params.has_key?(:from) ? params[:from] : self.all

        if params.has_key?(:from) && !(params.has_key?(:distance) || params.has_key?(:min_rooms))
          raise FindError, "Supplied params incorrect for :from:#{params[:from]} (:distance:#{params[:distance]}, :min_rooms:#{params[:min_rooms]}) " #[#{params}]"
        end

        result = dataset.each do |p|
          params.each do |k,v|
            case k
            when :distance
              raise FindError unless params.has_key?(:from)

              data = p.within(v, params[:ordered])

              %w{distance from ordered}.each {|s| params.delete(s.to_sym) }
              new_params = params.merge(from: data)

              return params.empty? ? data : find(new_params)
              data
            when :min_rooms
              return p.rooms(dataset: params[:from], min: v)
            end
          end
        end

        a = dataset.find_all do |p|
          b = params.map do |k,v|
            case v
            when String then p.send(k) =~ /#{v}/i
            when Fixnum then p.send(k) == v
            end
          end
          b.all?
        end
      end

    end
  end
end
