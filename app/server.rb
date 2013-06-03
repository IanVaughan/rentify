require "sinatra/base"
require './app/helpers'
require 'logger'

module Rentify
  class Server < Sinatra::Base
    configure :production, :development do
      enable :logging
      set :raise_errors, true
      set :show_exceptions, false
    end

    helpers Helpers

    get '/' do
      logger.info "hello"
      "hello"
    end

    get '/nearest_to' do
      content_type :json
      Property.find(:id => params[:id]).within(params[:distance].to_i).to_json
    end

    get '/_info' do
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
