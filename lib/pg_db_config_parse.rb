require 'pg'
require 'dotenv'

Dotenv.load

# ----------------------- HEROKU DB CONFIG  ------------------------
if ENV['RACK_ENV'] == "production"
	db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
	CONN = PGconn.connect(host: db_parts[5], port: db_parts[6], dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
else
	#----------------------- CONNECT DATABASE LOCALHOST ----------------------
	CONN = PGconn.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
end
