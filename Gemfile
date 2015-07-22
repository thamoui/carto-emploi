source 'https://rubygems.org'

ruby '1.9.3'

gem "rack"
gem "sinatra"#, git: 'https://github.com/sinatra/sinatra.git'
gem "activesupport"
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
gem "newrelic_rpm"
gem "newrelic_plugin"
gem "newrelic_postgres_plugin"
gem "therubyracer"

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
