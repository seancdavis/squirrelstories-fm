source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ---------------------------------------- | Base

gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'

# ---------------------------------------- | Styles

gem 'bootstrap'
gem 'sass-rails', '~> 5.0'

# ---------------------------------------- | JavaScripts

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

# ---------------------------------------- | Utilities

gem 'actionpack-action_caching'
gem 'figaro'
gem 'hashie'
gem 'nokogiri'
gem 'rest-client'

group :development do
  gem 'faker'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# ---------------------------------------- | Testing

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

# ---------------------------------------- | Errors / Debugging

group :development do
  gem 'web-console', '>= 3.3.0'
end
