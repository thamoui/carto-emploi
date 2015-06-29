source 'https://rubygems.org'

ruby '2.1.3'

gem "rack"
gem "sinatra", git: 'https://github.com/sinatra/sinatra.git'
gem "activesupport"
gem "puma"
gem "rake"
gem "sinatra-activerecord"
gem "activerecord"
gem "json"
gem "nokogiri"
gem "dotenv"
gem "geocoder"
gem "geokit"
gem "clockwork"
gem "pg"
gem "sidekiq"
gem "activesupport"
gem "newrelic_rpm"

group :production do
end

group :development do
  gem "sinatra-reloader"
  gem "shotgun"
  gem "colorize" #ne fonctionne pas sur heroku mais bien utile pour mieux visualiser les logs sur sa machine
  gem "pry"
end

group :test do
  gem "rspec"
  gem "rack-test"
end
