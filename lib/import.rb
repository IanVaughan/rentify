require 'json'

module Rentify
  class Import
    def self.import data_or_filename
      input = read_data data_or_filename
      data = []

      input.split(/Flat [0-9]/).each_with_index do |line, i|
        next if line.nil? || line['name'].nil?
        json = JSON.parse("{#{line}}", :symbolize_names => true)
        data << {id: "Flat #{i}"}.merge(json)
      end
      data
    end

    private

    def self.read_data source
      return File.read(source.to_str) if File.exists? source
      source
    end
  end
end
