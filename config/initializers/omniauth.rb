Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.secrets.google_client_id, Rails.secrets.google_client_secret
end