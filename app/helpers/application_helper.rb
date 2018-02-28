module ApplicationHelper

  # ---------------------------------------- | Environments

  def dev?
    Rails.env.development?
  end

  def test?
    Rails.env.test?
  end

  # ---------------------------------------- | Routing / Navigation

  def active_nav?(type, value)
    case type.to_sym
    when :segment
      request.path.split('/').reject(&:blank?).include?(value)
    when :path
      request.path == value
    else
      false
    end
  end

  # ---------------------------------------- | Social

  def facebook_share_url(url = request.original_url)
    p = { u: url }.to_param
    "https://www.facebook.com/sharer/sharer.php?#{p}"
  end

  def twitter_share_url(text = nil, url = request.original_url)
    p = { status: url }.to_param
    "https://twitter.com/home?#{p}"
  end

end
