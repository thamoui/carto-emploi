require './carto_emploi'
require './admin'

run Sinatra::Application

require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV['SIDEKIQ_USER_NAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end

  run Sidekiq::Web
end


use Rack::Session::Cookie, :key => ENV['SESSION_KEY'],
                           #:domain => 'localhost', en prod, on met quoi ?
                           :path => '/admin',
                           :expire_after => 360, # In seconds
                           :secret => ENV['SESSION_SECRET']

# >>>> il faut créer un compte d'abord https://github.com/mperham/sidekiq/wiki/Monitoring
#https://github.com/settings/applications/new


# require 'sidekiq'
# require 'sidekiq/web'
#
# Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
#   [user, password] == ["sidekiqadmin", "yourpassword"]
# end
