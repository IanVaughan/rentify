module Rentify
  module Helpers
    FIND_KEYS = [:id, :name, :bedroom_count]
    def validated p
      params = {}
      p.each {|k,v| params[k.to_sym] = v}
      params.keep_if { |key| FIND_KEYS.include? key.to_sym }
      params[:bedroom_count] = params[:bedroom_count].to_i if params.include?(:bedroom_count)
      params
    end

    def last_search field
      if session.has_key?(:last_search) && session[:last_search].has_key?(field.to_sym)
        session[:last_search][field.to_sym]
      else
        ''
      end
    end


    NUMBER_TO_ADD = 100
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

    def add_random_seed_data
      NUMBER_TO_ADD.times.collect { Rentify::Property.add get_add_data }
    end
  end
end
