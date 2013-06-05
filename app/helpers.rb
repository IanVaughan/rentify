require './lib/property'
require './lib/import'

module Rentify
  module Helpers
    def validated params
      params = symbolise(params)
      params = remove_invalid_keys(params)

      if params.include?(:bedroom_count)
        if params[:bedroom_count] == ''
          params.delete(:bedroom_count)
        else
          params[:bedroom_count] = params[:bedroom_count].to_i
        end
      end
      params
    end

    def symbolise params
      ret = {}
      params.each { |k,v| ret[k.to_sym] = v }
      ret
    end

    VALID_KEYS = [:id, :name, :bedroom_count]
    def remove_invalid_keys params
      params.keep_if { |key| VALID_KEYS.include? key }
    end

    def last_search field
      if session.has_key?(:last_search) && session[:last_search].has_key?(field.to_sym)
        session[:last_search][field.to_sym]
      else
        ''
      end
    end

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

    def add_random_seed_data number = 10
      number.times.collect { Property.add get_add_data }
    end

    def clear_seed_data
      Property.clear
    end

    def load_test_data
      data = Import.import('./import/data.txt')
      data.each { |d| Property.add d }
    end
  end
end
