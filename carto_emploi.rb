require 'sinatra'
require 'json'
require 'pg'
require 'dotenv'
require 'active_support/all'
require 'active_record'
require 'sinatra/activerecord'

Dotenv.load

# ----------------- CONFIGURATION DATAS ----------------------

configure { set :server, :puma }
set :public_folder, 'public'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] ||= 'super secret'
end


#add new relic in addons for Software Analytics, Application Performance Mangement
configure :production do
  require 'newrelic_rpm'
end

#------------------------ config.time_zone = 'Europe/Paris'-----
Time.zone = "UTC"
ActiveRecord::Base.default_timezone = :utc

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

before do
  @conn = settings.conn
end

set :public_folder, 'frontend' #this is necessary to be able to access to static files
get '/' do
  redirect '/index.html' #The root of the project is /frontend so the absolute path to static files doesn't need /frontend in front
end

#----------------- /metiers : renvoie la liste des metiers
get '/metiers' do
  content_type :json, 'charset' => 'utf-8'
  @data_job = []
  @conn.exec("SELECT * FROM job_lists").map do |result|
    @data_job << result
  end
  @data_job.to_json
end

#--------------   /geosearch/LAT,LNG : renvoie les emplois aux alentours
get '/geosearch/:lat,:lng' do
  #geosearch/48.86833,2.66833?p=42&limit=42&text=developpeur LAGNY SUR MARNE
  #TESTER AVEC CES VALEURS POUR EVRY
  # @lat = 48.629828
  # @lng = 2.441782


  puts "--------- GEOSEARCH CONN CLASS : #{@conn.class}"

  #------------ Checking if there is a connection do database
  check_connection(@conn)
  #------------ end checking

  content_type :json, 'charset' => 'utf-8'

  @lat = params[:lat]
  @lng = params[:lng]
  job = params['text']
  @distance = params['d']
  page = params['p'].to_i
  limit_given = params['limit'].to_i
  @data_job = []
  bg_offers = 0

  if @distance == nil || @distance == ""
    @distance = 50
  end

  #////////////////////////////// PAGINATION ///////////////////////
  #----------- Counting number of all offers in database -----------------------
  total_offers = @conn.exec("SELECT COUNT (id_key) FROM job_offers")
    @total = total_offers[0]["count"].to_i
    puts "---------------> number of offers in db #{@total}"

  if limit_given == 0 #afficher, 10, 20 ou 50 annonces, bouge suivant le nbre d'offers disponibles dans la BDD
    limit = 100 #afficher, 10, 20 ou 50 annonces, nombre fixe
    bg_offers = limit_given
    page = 0
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> case limit==0 : this is nb of pages availables for pagination :  #{all_pages}"
  else
    limit = limit_given
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> case limit >0 : #{all_pages} pages availables for pagination"
    bg_offers = limit_given - limit
    puts "------------------BG_OFFER #{bg_offers}"
    if page >= 1 && page <= all_pages
      bg_offers = limit_given * (page - 1)
    end
  end
  #///////////////////////////// ENF OF PAGINATION ////////////////////////

  if job == nil || job == ""
    sql = ""
  else
    #sql = "AND to_tsvector('french', offer_description || ' ' || title) @@ plainto_tsquery('french', '#{job}')"
    sql = "AND title LIKE '%#{job}%'"
  end
  requete_sql = "SELECT *, distance FROM (SELECT *, ( 6371 * acos( cos( radians( #{@lat} ) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(#{@lng}) ) + sin( radians(#{@lat}) ) * sin( radians( latitude ) ) ) ) AS distance FROM job_offers ) AS dt WHERE distance < #{@distance} #{sql} ORDER BY publication_date DESC LIMIT #{limit} OFFSET #{bg_offers} ;"
  result = @conn.exec(requete_sql)

  puts "------------- this is RESULT #{result.inspect}-----------"

  result.map do |data|
    puts "---- #{data["publication_date"]}  // //  #{data["region_adress"]} //  #{data["id_key"]} // #{data["offer_id"]} : #{data["title"]}"
    @data_job << data
  end

  if @data_job == [] #an empty data is analysed by index.html
    [].to_json
  else
    @data_job.to_json
  end
end


# ------------- Message d'erreur personnalisé
error do
   @error = env['sinatra.error']
   erb :err500, :locals => {:error => error}
 end
