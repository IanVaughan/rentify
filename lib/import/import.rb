require 'json'

module Rentify
  class Import
    def self.import input
      data = []

      input.split(/Flat ./).each_with_index do |line, i|
        next if line.nil? || line['name'].nil?
        data << {id: "Flat #{i}"}.merge(JSON.parse("{#{line}}"))
      end
      data
    end
  end
end
