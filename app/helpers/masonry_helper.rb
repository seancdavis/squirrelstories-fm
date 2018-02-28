module MasonryHelper

  def random_masonry_class
    %w[masonry--bg-yellow masonry--bg-teal masonry--bg-gray].sample(1).first
  end

  def masonry_font_size_class(text)
    return 'masonry--text-xl' if text.size <= 32
    return 'masonry--text-lg' if text.size <= 100
    ''
  end

end
