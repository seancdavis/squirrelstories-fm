require 'hashie'
require 'json'
require 'nokogiri'
require 'rest-client'
require 'rexml/document'
require 'yaml'

# ---------------------------------------- | Sync Sapwood Data

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

# ---------------------------------------- | Build SVG Icon Sprite

desc 'Combine all SVG icons into a single SVG'
task :build_svg do
  icons_dir = File.expand_path('source/images/icons', __dir__)

  svg_content = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"

  Dir.glob("#{icons_dir}/*.svg").each do |file|
    doc = Nokogiri::XML(File.read(file))
    el = (doc.css('#Page-1 > g')[0] || doc.css('svg > g')[0])
    content = el.to_s
    icon_name = el['id']
    svg_content += "<svg width=\"256px\" height=\"256px\" viewBox=\"0 0 256 256\" id=\"#{icon_name}\">\
  #{content.gsub(/[a-z\-]+=\"[a-zA-Z0-9\-\#]+\"/, '')}\
</svg>"
  end
  svg_content += '</svg>'

  svg_content = REXML::Document.new(svg_content)
  output = ''
  svg_content.write(output, 2)

  icons_file = File.expand_path('source/images/icons.svg', __dir__)
  File.open(icons_file, 'w+') { |file| file.write(output) }
end
