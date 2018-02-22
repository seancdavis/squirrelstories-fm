# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

data.episodes.each do |episode|
  proxy "/episodes/#{episode.number}/#{episode.slug}/index.html", "/templates/episode.html", locals: { episode: episode, title: episode.name }, ignore: true
end

data.quotes.each do |quote|
  proxy "/quotes/#{quote.episode.id}/#{quote.id}/index.html", "/templates/quote.html", locals: { quote: quote, title: 'Squirrel Stories Quote' }, ignore: true
end

data.pages.each do |page|
  proxy "/#{page.page_path}/index.html", "/templates/page.html", locals: { page: page, title: "Squirrel Stories | #{page.name}" }, ignore: true
end

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do

  def page_title
    return current_page.metadata[:locals][:title] if current_page.metadata[:locals][:title]
    return current_page.data.title if current_page.data.title
    data.settings.site.title
  end

  def icon(name, options = {})
    classes = "icon icon-#{name} #{options[:size]} #{options[:class]}"
    content_tag(:svg, class: classes, 'viewBox': '0 0 32 32') do
      href = "#{image_path('icons.svg')}##{name}"
      content_tag(:use, nil, 'xlink:href': href, height: '32', width: '32')
    end
  end

  def active_nav?(type, value)
    case type.to_sym
    when :segment
      current_page.path.split('/').reject(&:blank?).include?(value)
    when :path
      current_page.path == value
    else
      false
    end
  end

  def random_masonry_class
    %w[masonry--bg-yellow masonry--bg-teal masonry--bg-gray].sample(1).first
  end

  def masonry_font_size_class(text)
    return 'masonry--text-xl' if text.size <= 32
    return 'masonry--text-lg' if text.size <= 100
    ''
  end

  def facebook_share_url(url = current_page.path)
    p = { u: url }.to_param
    "https://www.facebook.com/sharer/sharer.php?#{p}"
  end

  def twitter_share_url(text = nil, url = current_page.path)
    p = { status: url }.to_param
    "https://twitter.com/home?#{p}"
  end

  def episode_path(episode)
    "/episodes/#{episode.number}/#{episode.slug}"
  end

  def quote_path(quote)
    "/quotes/#{quote.episode.id}/#{quote.id}"
  end

end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end

before_build do
  system("bundle exec rake sync_sapwood")
end
