source 'https://rubygems.org'

#--------------------------------------------------------------------------------------------------
# Run with: ARCHFLAGS="-arch x86_64" bundle install
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# Core
gem 'rails', '~> 5.2'
gem 'mysql2', '~> 0.4'                    # MySQL

# http://sass-lang.com
gem 'sass-rails', '~> 5.0'                # Use SCSS for stylesheets

# http://haml.info
gem 'haml', '~> 5.0'                      # Use HAML for views
# gem 'erubis', '~>2.7.0'                   # Include ERB for temporary use

# http://fortawesome.github.io/Font-Awesome/
# https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass', '~> 5.0'

gem 'nokogiri', '~> 1.8.2'                # Force Nokogiri past CVE-2017-9050
gem 'uglifier', '>= 1.3'                  # Use Uglifier as compressor for JavaScript assets

# https://github.com/adzap/timeliness
gem 'timeliness', '~>0.3'                 # Date and Time parsing

# https://github.com/adzap/validates_timeliness
gem 'validates_timeliness', '~>4.0'       # Date and Time validation

# https://github.com/dgilperez/validates_zipcode
gem 'validates_zipcode', '~> 0.0.17'       # Zipcode validation

gem 'jquery-rails'                        # Use jquery as the JavaScript library
gem 'jbuilder', '~> 2.0'                  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4', group: :doc         # bundle exec rake doc:rails generates the API under doc/api.

# gem 'unicorn'                             # Use Unicorn as the app server
# gem 'thin'                                # Use thin for the web server
gem 'puma', '~> 3.6'                        # Use Puma for the web server

# https://github.com/Shopify/bootsnap -- load performance improvement
gem 'bootsnap', require: false

#--------------------------------------------------------------------------------------------------
# AuthN / AuthZ
# http://devise.plataformatec.com.br
gem 'devise', '~> 4.4'                    # Use Devise for authN

# https://github.com/intridea/omniauth
gem 'omniauth', '~> 1.8'                # Use OmniAuth for authN
gem 'omniauth-oauth', '~> 1.1'            # Use OmniAuth for OAuth2
gem 'omniauth-oauth2', '~> 1.5'           # Use OmniAuth for OAuth2

# https://github.com/nathanl/authority
# https://www.rubydoc.info/gems/authority/3.3.0
gem 'authority', '~> 3.3'                 # Use Authority for authZ

# See https://github.com/intridea/omniauth/wiki/List-of-Strategies for strategies
gem 'omniauth-facebook', '~> 4.0'         # Use OmniAuth for Facebook, see https://github.com/mkdynamic/omniauth-facebook
gem 'omniauth-google-oauth2', '~> 0.5'    # Use OmniAuth for Google, see https://github.com/zquestz/omniauth-google-oauth2
gem 'omniauth-linkedin', '~> 0.2'         # Use OmniAuth for LinkedIn, see https://github.com/decioferreira/omniauth-linkedin-oauth2
gem 'omniauth-twitter', '~> 1.4'          # Use OmniAuth for Twitter, see https://github.com/arunagw/omniauth-twitter

# gem 'therubyracer', platforms: :ruby    # See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'bcrypt', '~> 3.1.7'                # Use ActiveModel has_secure_password
# gem 'turbolinks'                        # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks

group :development do
  gem 'web-console', '~> 3.4'             # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'foreman'                           # Foreman to run dependent processes. Read more: https://github.com/ddollar/foreman
end

group :development, :test do
  gem 'annotate', '~> 2.7'                # Annotate models
  gem 'byebug'                            # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'spring'                            # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

  # https://github.com/thoughtbot/factory_bot/blob/v4.9.0/GETTING_STARTED.md
  # https://www.rubydoc.info/gems/factory_bot/file/README.md
  gem 'factory_bot_rails', '~> 4.8'      # Use FactoryBot for seeds and what not

  # https://github.com/rspec/rspec-expectations
  # http://rspec.info/documentation/
  # http://www.rubydoc.info/gems/rspec-rails/file/README.md
  gem 'rspec', '~> 3.7'                   # Use Rspec for testing, see http://rspec.info/
  gem 'rspec-rails', '~> 3.7'             # See https://relishapp.com/rspec/rspec-rails/v/3-4/docs
  gem 'rspec-activemodel-mocks'           # See https://github.com/rspec/rspec-activemodel-mocks/
  gem 'spring-commands-rspec'             # Enable Spring optimized loads for Rspec
  gem 'capybara'                          # Enable integration testing
  gem 'rails-controller-testing'

  gem 'ripper-tags'                       # For CTAGs support
end
