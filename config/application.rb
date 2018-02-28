require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SquirrelStories
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.generators do |g|
      # g.fixture true
      # g.fixture_replacement "factory_girl"
      # g.test_framework :rspec
      g.assets false
      g.view_specs false
      g.model_specs true
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.skip_routes true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
