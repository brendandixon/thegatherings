Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  # provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
  # provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
  # provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

OmniAuth.config.logger = Rails.logger
