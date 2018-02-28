module Sapwood
  class QuoteService < BaseService

    api_methods :get_all, :get

    def get_all
      api_get('elements', template: 'Quote')
    end

    def get(id)
      get_all.select { |ep| ep.id.to_i == id.to_i }.first
    end

  end
end
