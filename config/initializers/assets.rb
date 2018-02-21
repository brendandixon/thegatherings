# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( vendor/assets/modernizr/3.2.0/modernizr-all.min.js  )

# See https://github.com/rails/sprockets
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'foundation-icons')
Rails.application.config.assets.paths << Rails.root.join(ENV['RAILS_ASSET_PATH'], 'node_modules')
Rails.application.config.assets.paths << Rails.root.join(ENV['RAILS_ASSET_PATH'], 'node_modules', 'foundation-sites', 'scss')
Rails.application.config.assets.paths << Rails.root.join(ENV['RAILS_ASSET_PATH'], 'node_modules', 'foundation-sites', 'dist')

Rails.application.config.assets.precompile += %w( foundation-sites/dist/js/foundation.js what-input/what-input.js charts.js cards.js dates.js )
Rails.application.config.assets.precompile += %w( c3/c3.min.css )
