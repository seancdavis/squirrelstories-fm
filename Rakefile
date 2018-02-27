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

  def write_collection(filename, collection)
    dest_file = File.expand_path("data/#{filename}.yml", File.dirname(__FILE__))
    File.open(dest_file, 'w+') { |file| file.write(collection.to_yaml) }
  end

  def write_collection_from_api(filename, api_path, options = {})
    collection = api_get(api_path, options)
    write_collection(filename, collection)
  end

  # Episodes
  episodes = api_get('elements', template: 'Episode', sort_by: 'number', sort_in: 'desc', includes: 'quotes')
  write_collection('episodes', episodes)

  # Quotes
  write_collection_from_api('quotes', 'elements', template: 'Quote')

  # Pages
  write_collection_from_api('pages', 'elements', template: 'Page')

  # Storytellers
  published_stories = []
  storytellers = []
  episodes.each do |episode|
    episode.stories.each do |story|
      story.episode = episode
      published_stories << story
    end
  end
  published_stories.flatten.uniq.group_by(&:storyteller).each do |storyteller, stories|
    # storyteller.stories = stories
    storyteller.episodes = stories.collect(&:episode)
    storytellers << storyteller
  end
  write_collection('storytellers', storytellers)

end
