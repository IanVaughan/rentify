module Rentify
  module Helpers
    FIND_KEYS = [:id, :name]
    def validated params
      params.keep_if { |key| FIND_KEYS.include? key.to_sym }
    end
  end
end
