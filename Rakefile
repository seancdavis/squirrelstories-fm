require 'hashie'
require 'rest-client'
require 'json'
require 'yaml'

desc 'Sync Sapwood API'
task :sync_sapwood do

  # api_key = ENV['sapwood_api_key']
  # property_id = ENV['sapwood_property_id']
  # domain = ENV['sapwood_domain']
  api_key = '813fcd985cae3287ff84097625245bbf2dccb7ed7b8fff0445'
  property_id = '2'
  domain = 'sapwood.seancdavis.me'
  base_url = "https://#{domain}/api/v1/properties/#{property_id}"
  # base_options = { api_key: api_key }

  path = 'elements'
  api_url = "#{base_url}/#{path}.json"
  options = { template: 'Episode', sort_by: 'number', sort_in: 'desc', api_key: api_key }

  req = RestClient.get(api_url, params: options)
  collection = JSON.parse(req.body).map { |el| Hashie::Mash.new(el) }

  dest_file = File.expand_path('data/episodes.yml', File.dirname(__FILE__))

  File.open(dest_file, 'w+') { |file| file.write(collection.to_yaml) }

  # puts collection.to_yaml
end
