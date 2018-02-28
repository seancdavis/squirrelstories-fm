module Sapwood
  class EpisodeService < BaseService

    api_methods :get_all, :get

    def get_all
      api_get('elements', template: 'Episode', sort_by: 'number', sort_in: 'desc')
    end

    def get(slug)
      get_all.select { |ep| ep.slug == slug }.first
    end

  end
end
