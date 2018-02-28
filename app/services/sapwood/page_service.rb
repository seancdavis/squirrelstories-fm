module Sapwood
  class PageService < BaseService

    api_methods :get_all, :get_by_path

    def get_all
      api_get('elements', template: 'Page')
    end

    def get_by_path(path)
      get_all.select { |page| page.page_path == path }.first
    end

  end
end
