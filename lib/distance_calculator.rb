module Rentify

  RADIUS_OF_THE_EARTH = 6371
  RADIANS_CONVERSION_FACTOR = 180 / Math::PI

  module DistanceCalculator
    include Enumerable

    def distance_to dest
      DistanceCalculator.distance_between(self, dest)
    end


    def self.distance_between(origin, destination)
      sin_lats = Math.sin(rad(origin.latitude)) * Math.sin(rad(destination.latitude))
      cos_lats = Math.cos(rad(origin.latitude)) * Math.cos(rad(destination.latitude))
      cos_longs = Math.cos(rad(destination.longitude) - rad(origin.longitude))

      x = sin_lats + (cos_lats * cos_longs)
      x = [x, 1.0].min
      x = [x, -1.0].max

      Math.acos(x) * RADIUS_OF_THE_EARTH
    end

    def self.rad degree
      degree / RADIANS_CONVERSION_FACTOR
    end

  end
end
