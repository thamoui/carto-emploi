web: rackup -s puma -p $PORT

worker: bundle exec sidekiq
worker: bundle exec pg_monitor run
