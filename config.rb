# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :external_pipeline,
  name: :rollup,
  command: build? ? 'npm run build:clean' : 'npm run dev',
  source: '.tmp/dist',
  latency: 1

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

data.episodes.each do |episode|
  proxy "/episodes/#{episode.number}/#{episode.slug}/index.html", "/templates/episode.html", locals: { episode: episode, title: "#{episode.name} | Squirrel Stories", description: episode.description, ix_image: episode.image.try(:url) }, ignore: true
end

data.storytellers.each do |storyteller|
  proxy "/storyteller/#{storyteller.id}-#{storyteller.slug}/index.html", "/templates/storyteller.html", locals: { storyteller: storyteller, title: "Episodes with #{storyteller.name} | Squirrel Stories", description: "Episodes with stories told by #{storyteller.name}" }, ignore: true
end

data.quotes.each do |quote|
  proxy "/quotes/#{quote.episode.id}/#{quote.id}/index.html", "/templates/quote.html", locals: { quote: quote, title: "Quote from Episode #{quote.episode.number} | Squirrel Stories", description: "A quote by #{quote.storyteller.name} from episode #{quote.episode.number}" }, ignore: true
end

data.pages.each do |page|
  proxy "/#{page.page_path}/index.html", "/templates/page.html", locals: { page: page, title: "#{page.name} | Squirrel Stories", description: page.meta_description }, ignore: true
end

ignore 'templates/*'
ignore 'javascripts/manifest.js'
ignore 'javascripts/components/*'
ignore 'javascripts/utilities/*'
ignore 'javascripts/vendor/*'

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

  def page_description
    return current_page.metadata[:locals][:description] if current_page.metadata[:locals][:description]
    return current_page.data.description if current_page.data.description
    data.settings.site.description
  end

  def page_image
    return current_page.metadata[:locals][:image] if current_page.metadata[:locals][:image]
    return current_page.data.image if current_page.data.image
    if current_page.metadata[:locals][:ix_image]
      return ix_url(current_page.metadata[:locals][:ix_image], w: 1200, h: 1200, fit: 'crop')
    end
    data.settings.site.base_url + image_path('squirrel-stories-logo--teal--og.png')
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

  def storyteller_path(storyteller)
    "/storyteller/#{storyteller.id}-#{storyteller.slug}"
  end

  def s3_img_path(s3_url)
    return '' if s3_url.blank?
    URI.parse(s3_url).path[1..-1]
  end

  def ix_client
    @ix_client ||= Imgix::Client.new(host: 'sapwood.imgix.net', secure_url_token: 'qmNcr67W7y89zkKZ')
  end

  def ix_url(image_url, opts = {})
    return '' if image_url.blank?
    options = { auto: 'format' }.merge(opts)
    img_path = URI.parse(image_url).path
    ix_client.path(img_path).to_url(options)
  end

  def ix_breakpoint_width(breakpoint)
    case breakpoint.to_sym
    when :sm
      576
    when :md
      768
    when :lg
      992
    when :xl
      1200
    end
  end

  def ix_img_size(breakpoint, rem)
    "(min-width: #{ix_breakpoint_width(breakpoint)}px) #{16 * rem}w"
  end

  def ix_img_sizes(sizes)
    output = []
    sizes.each { |bp, sz| output << ix_img_size(bp, sz) }
    output << '100vw'
    output.join(',')
  end

  def ix_max_img_size(sizes, ratio)
    max_size = ix_breakpoint_width(sizes.sort_by{ |_k, v| v }.first.first)
    sizes.each do |bp, sz|
      size = sz * 16
      max_size = size if size > max_size
    end
    ((max_size * 2) + 50).round(-2)
  end

  def ix_srcset(url, sizes, ratio)
    output = []
    max_size = ix_max_img_size(sizes, ratio)
    (max_size / 100).times do |idx|
      width = (idx + 1) * 100
      height = width / ratio
      output << "#{ix_url(url, w: width, h: height, fit: 'crop')} #{width}w"
    end
    output.join(',')
  end

  def ix_img(orig_url, opts = {})
    return '' if orig_url.blank?
    sizes = ix_max_img_size(opts[:sizes], opts[:ratio])
    srcset = ix_srcset(orig_url, opts[:sizes], opts[:ratio])
    orig_src = ix_url(orig_url)
    "<img src=\"#{orig_src}\" srcset=\"#{srcset}\" sizes=\"#{sizes}\" class=\"#{opts[:class]}\">"
  end

end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css
  # activate :minify_javascript
  activate :gzip
  activate :asset_hash
  activate :minify_html
end

before_build do
  system("bundle exec rake sync_sapwood")
end
