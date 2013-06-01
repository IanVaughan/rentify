require 'json'

module Rentify
  class Import
    def self.import input
      # read = read_data input
      data = []

      input.split(/Flat ./).each_with_index do |line, i|
        next if line.nil? || line['name'].nil?
        data << {id: "Flat #{i}"}.merge(JSON.parse("{#{line}}", :symbolize_names => true))
      end
      data
    end

    private

    # def read_data source
    #   return source.read if source.respond_to?(:read)
    #   return File.read(source.to_str) if source.respond_to?(:to_str)
    #   raise ArgumentError
    # end
  end
end
