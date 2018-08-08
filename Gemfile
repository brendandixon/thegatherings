source 'https://rubygems.org'

#--------------------------------------------------------------------------------------------------
# Run with: ARCHFLAGS="-arch x86_64" bundle install
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# Core
gem 'rails', '~> 5.2.1'
gem 'mysql2', '~> 0.5.2'                    # MySQL

# http://sass-lang.com
gem 'sassc-rails', '~> 1.3.0'               # Use SCSS for stylesheets

# http://slim-lang.com
gem 'slim', '~> 3.0.9'                      # Use Slim for views

# https://www.rubydoc.info/gems/responders/2.4.0
gem 'responders', '~>2.4.0'

gem 'puma', '~> 3.6'                        # Use Puma for the web server

gem 'turbolinks', '~> 5'

# http://fortawesome.github.io/Font-Awesome/
# https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass', '~> 5.2.0'

gem 'nokogiri', '~> 1.8.4'
gem 'uglifier', '>= 4.1.18'                 # Use Uglifier as compressor for JavaScript assets

# https://github.com/adzap/timeliness
gem 'timeliness', '~>0.3.8'                 # Date and Time parsing

# https://github.com/adzap/validates_timeliness
gem 'validates_timeliness', '~>4.0.02'      # Date and Time validation

# https://github.com/dgilperez/validates_zipcode
gem 'validates_zipcode', '~> 0.1.0'         # Zipcode validation

gem 'jquery-rails'                          # Use jquery as the JavaScript library
gem 'jbuilder', '~> 2.7.0'                  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 1.0.0', group: :doc         # bundle exec rake doc:rails generates the API under doc/api.

# https://github.com/Shopify/bootsnap -- load performance improvement
gem 'bootsnap', '>= 1.3.0', require: false

# https://github.com/rails/webpacker
# https://webpack.js.org
# You need to allow webpack-dev-server host as allowed origin for connect-src.
# This can be done in Rails 5.2+ for development environment in the CSP initializer
# config/initializers/content_security_policy.rb with a snippet like this:
# policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
gem 'webpacker', '~> 3.5.5'

# https://github.com/reactjs/react-rails
gem 'react-rails', '~> 2.4.7'

#--------------------------------------------------------------------------------------------------
# AuthN / AuthZ
# http://devise.plataformatec.com.br
gem 'devise', '~> 4.4.3'                     # Use Devise for authN

# https://github.com/intridea/omniauth
# See https://github.com/intridea/omniauth/wiki/List-of-Strategies for strategies
# gem 'omniauth', '~> 1.8.1'                # Use OmniAuth for authN
# gem 'omniauth-oauth', '~> 1.1.0'          # Use OmniAuth for OAuth2
# gem 'omniauth-oauth2', '~> 1.5.0'         # Use OmniAuth for OAuth2
# gem 'omniauth-facebook', '~> 5.0.0'       # Use OmniAuth for Facebook, see https://github.com/mkdynamic/omniauth-facebook
# gem 'omniauth-google-oauth2', '~> 0.5.3'  # Use OmniAuth for Google, see https://github.com/zquestz/omniauth-google-oauth2
# gem 'omniauth-linkedin', '~> 0.2.0'       # Use OmniAuth for LinkedIn, see https://github.com/decioferreira/omniauth-linkedin-oauth2
# gem 'omniauth-twitter', '~> 1.4.0'        # Use OmniAuth for Twitter, see https://github.com/arunagw/omniauth-twitter

# https://github.com/nathanl/authority
# https://www.rubydoc.info/gems/authority/3.3.0
gem 'authority', '~> 3.3.0'                 # Use Authority for authZ

gem 'bcrypt', '~> 3.1.12'                   # Use ActiveModel has_secure_password

group :development do
  gem 'annotate', '~> 2.7.4'                # Annotate models
  gem 'spring', '~> 2.0.2'                  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'web-console', '~> 3.4'               # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'byebug', '~>10.0.2'                  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
end

group :development, :test do
  # https://github.com/thoughtbot/factory_bot/blob/v4.9.0/GETTING_STARTED.md
  # https://www.rubydoc.info/gems/factory_bot/file/README.md
  gem 'factory_bot_rails', '~> 4.10.0'      # Use FactoryBot for seeds and what not

  # https://github.com/rspec/rspec-expectations
  # http://rspec.info/documentation/
  # http://www.rubydoc.info/gems/rspec-rails/file/README.md
  gem 'rspec', '~> 3.8.0'                   # Use Rspec for testing, see http://rspec.info/
  gem 'rspec-rails', '~> 3.8.0'             # See https://relishapp.com/rspec/rspec-rails/v/3-4/docs
  gem 'rspec-activemodel-mocks', '~>1.0.3'  # See https://github.com/rspec/rspec-activemodel-mocks/
  gem 'spring-commands-rspec', '~>1.0.4'    # Enable Spring optimized loads for Rspec
  gem 'capybara', '~>3.5.1'                 # Enable integration testing
  gem 'rails-controller-testing', '~>1.0.2'
end
