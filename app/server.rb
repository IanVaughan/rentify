require "sinatra/base"
require './app/helpers'
require 'logger'

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

    # Not used in app yet
    get '/find' do
      content_type :json
      a = Property.find(validated(params))
      a.first.to_json
    end

    get '/property' do
      distance = params.has_key?('distance') ? params['distance'].to_i : 20
      property = Property.find(validated(params))
      property = property.first

      property.rooms(min: 2)
      others = property.within(distance)
      erb :property_detail,
          :locals => {
            property: property,
            others: others
          }
    end

    # Not used in app yet
    get '/nearest_to' do
      content_type :json
      Property.find(:id => params[:id]).first.within(params[:distance].to_i).to_json
    end

    get '/_info' do
      content_type :json
      # return in either both or YAML
      <<-ENDRESPONSE
        Ruby:    #{RUBY_VERSION}
        Rack:    #{Rack::VERSION}
        Sinatra: #{Sinatra::VERSION}
        #{session.inspect}
      ENDRESPONSE
    end
  end
end
