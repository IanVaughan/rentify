require "sinatra/base"
require './app/helpers'

include Rentify::Helpers
Rentify::Helpers.load_test_data

module Rentify
  class Server < Sinatra::Base
    configure :production, :development do
      enable :logging
      enable :sessions
      set :raise_errors, true
      set :show_exceptions, false
    end

    helpers Helpers

    get '/' do
      erb :index
    end

    get '/search' do
      session[:last_search] = validated(params)

      erb :search,
          :locals => {
            properties: Property.find(validated(params))
          }
    end

    get '/map' do
      erb :map,
          :locals => { properties: Property.find(validated(params)) },
          :layout => :map_layout
    end

    get '/find' do
      content_type :json
      a = Property.find(validated(params))
      a.first.to_json
    end

    get '/property' do
      distance = params.has_key?('distance') ? params['distance'].to_i : 20
      property = Property.find(validated(params))
      property = property.first

      others = property.within(distance)
      others = property.rooms(dataset: others, min: property.bedroom_count)
      erb :property_detail,
          :locals => {
            property: property,
            others: others
          }
    end

    get '/about' do
      erb :about
    end

    get '/seed/add' do
      count = params.has_key?('count') ? params['count'].to_i : 10
      puts count
      add_random_seed_data count
      redirect '/'
    end

    get '/seed/clear' do
      clear_seed_data
      load_test_data
      redirect '/'
    end

    get '/_info' do
      content_type :json
      <<-ENDRESPONSE
        Ruby:    #{RUBY_VERSION}
        Rack:    #{Rack::VERSION}
        Sinatra: #{Sinatra::VERSION}
        #{session.inspect}
      ENDRESPONSE
    end
  end
end
