require 'bundler/setup'
require File.join(File.dirname(__FILE__), 'web_app.rb')

require 'sidekiq'
require 'sidekiq/web'

set :run, false
set :raise_errors, true

Sidekiq.configure_client do |config|
  config.redis = { size: 10, namespace: 'sidekiq-hk-bug' }
end

run Rack::URLMap.new('/' => Sinatra::Application, '/sidekiq' => Sidekiq::Web)
