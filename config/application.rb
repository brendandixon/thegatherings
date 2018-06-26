require File.expand_path('../boot', __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TheGatherings
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine = :slim
    end

    class << self
      attr_accessor :default_time_zone
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Use per-form CSRF tokens
    config.action_controller.per_form_csrf_tokens = true

    # Add Extensions to the autoload path
    config.autoload_paths << Rails.root.join("app", "models", "validators")
    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("lib", "extensions")
  end
end

TheGatherings::Application.default_time_zone = "Pacific Time (US & Canada)"
