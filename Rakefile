require 'hashie'
require 'rest-client'
require 'json'
require 'yaml'

desc 'Sync Sapwood API'
task :sync_sapwood do

  def api_get(path, options = {})
    api_key = '813fcd985cae3287ff84097625245bbf2dccb7ed7b8fff0445'
    property_id = '2'
    domain = 'sapwood.seancdavis.me'
    base_url = "https://#{domain}/api/v1/properties/#{property_id}"
    options[:api_key] = api_key unless options[:api_key]
    api_url = "#{base_url}/#{path}.json"
    req = RestClient.get(api_url, params: options)
    JSON.parse(req.body).map { |el| Hashie::Mash.new(el) }
  end

  def write_collection(filename, api_path, options = {})
    collection = api_get(api_path, options)
    dest_file = File.expand_path("data/#{filename}.yml", File.dirname(__FILE__))
    File.open(dest_file, 'w+') { |file| file.write(collection.to_yaml) }
  end

  write_collection('episodes', 'elements', template: 'Episode', sort_by: 'number', sort_in: 'desc')
  write_collection('quotes', 'elements', template: 'Quote')
  write_collection('pages', 'elements', template: 'Page')
end
