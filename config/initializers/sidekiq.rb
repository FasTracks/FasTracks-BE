Sidekiq.configure_server do |config|
  # server url will likely need to change for deployment
  config.redis = { url: 'redis://localhost:6379/0' }
end