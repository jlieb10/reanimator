Rails.application.config.middleware.use OmniAuth::Builder do
  secrets = Rails.application.secrets
  provider :google_oauth2, secrets.google_client_id, secrets.google_client_secret, secrets.google_omniauth_config
end