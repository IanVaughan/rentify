require "sinatra/base"

module Rentify
  class Server < Sinatra::Base
    configure :production, :development do
      enable :logging
      set :raise_errors, true
      set :show_exceptions, false
    end

    get '/' do
      logger.info "hello"
      "hello"
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
