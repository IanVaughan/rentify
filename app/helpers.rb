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
  end
end
