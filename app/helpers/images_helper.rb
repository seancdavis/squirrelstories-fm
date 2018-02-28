module ImagesHelper

  def icon(name, options = {})
    classes = "icon icon-#{name} #{options[:size]} #{options[:class]}"
    content_tag(:svg, class: classes, 'viewBox': '0 0 32 32') do
      href = "#{image_path('icons.svg')}##{name}"
      content_tag(:use, nil, 'xlink:href': href, height: '32', width: '32')
    end
  end

end
