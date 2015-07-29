require 'pg'
require 'dotenv'

Dotenv.load

#----------------------- DB CONFIG  ---------------------------
if ENV['RACK_ENV'] == "production"
  db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
  configure do
    set :conn, PG.connect(host: db_parts[5], port: db_parts[6], dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
  end
else
  require 'shotgun'
  configure do
    set :conn, PG.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
  end
end

# ------------- Methode qui checke avant une route si la connection est valide ------
def check_connection( conn )
  begin
    @conn.exec("SELECT 1")
  rescue PG::Error => err
    $stderr.puts "%p while CHECKING TESTING connection: %s" % [ err.class, err.message ]
    @conn.reset
    puts "--------- PG CONNECTION RESETED -------------"
  end
end
# ------------ End
