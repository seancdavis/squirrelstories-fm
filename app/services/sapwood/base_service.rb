module Sapwood
  class BaseService

    attr_accessor :base_url, :base_options

    def initialize(_ = {})
      set_property_options
    end

    def self.api_methods(*names)
      names.each do |name|
        self.define_singleton_method(name) do |args = {}|
          args.blank? ? new.send(name) : new.send(name, args)
        end
      end
    end

    private

      def set_property_options
        api_key = ENV['sapwood_api_key']
        property_id = ENV['sapwood_property_id']
        domain = ENV['sapwood_domain']
        self.base_url = "https://#{domain}/api/v1/properties/#{property_id}"
        self.base_options = { api_key: api_key }
      end

      def api_get(path, options = {})
        req = RestClient.get(api_url(path), params: options.reverse_merge(base_options))
        Rails.logger.info "[SAPWOOD API]: #{req.request.url}"
        JSON.parse(req.body).map { |el| Hashie::Mash.new(el) }
      end

      def api_url(path)
        "#{base_url}/#{path}.json"
      end

  end
end
