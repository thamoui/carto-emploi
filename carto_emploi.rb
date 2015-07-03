require 'sinatra'
require 'json'
require 'pg'
require 'dotenv'
require 'active_support/all'
require 'active_record'
Dotenv.load

# ----------------- CONFIGURATION DATAS ----------------------

configure { set :server, :puma }
set :public_folder, 'public'

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
    set :conn, PG.connect(host: db_parts[5], port: 5432, dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
  end
else
  require 'shotgun'
  configure do
    set :conn, PG.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
  end
end

before do
  @conn = settings.conn
end

set :public_folder, 'frontend' #this is necessary to be able to access to static files
get '/' do
  redirect '/index.html' #The root of the project is /frontend so the absolute path to static files doesn't need /frontend in front
end

# --------------- gestion des données en mode objet grâce à active records
class Job_list < ActiveRecord::Base
end
# !!!!!!!!!!!!!!!!! Voir si faut pas que j'importe le dossier models !!!!!!!!!!!

# --------------- /admin : interface d'administration

get '/admin' do
  erb :admin
end



#----------------- /metiers : renvoie la liste des métiers

get '/metiers' do
  content_type :json, 'charset' => 'utf-8'
  @data_job = []
  @conn.exec("SELECT * FROM job_list").map do |result|
  @data_job << result
  end
  @data_job.to_json
end


#--------------   /geosearch/LAT,LNG : renvoie les emplois aux alentours

get '/geosearch/:lat,:lng' do
  #geosearch/48.86833,2.66833?p=42&limit=42&text=développeur LAGNY SUR MARNE
  #TESTER AVEC CES VALEURS POUR EVRY
  # @lat = 48.629828
  # @lng = 2.441782

  content_type :json, 'charset' => 'utf-8'

  @lat = params[:lat]
  @lng = params[:lng]
  job = params['text']
  @distance = params['d']
  page = params['p'].to_i
  limit_given = params['limit'].to_i
  @data_job = []

  if @distance == nil || @distance == ""
    @distance = 50
  end

  puts "---------------- NEW SEARCH ------------------------- ----------------"
  puts "---------------- TEXT = #{job} ----------------------------------------"
  puts "---------------- D = #{@distance.class} ----------------------------------------"
  puts "---------------- LIMIT GIVEN : #{limit_given} -------------------------"

  #////////////////////////////// PAGINATION ///////////////////////


  #----------- Counting number of all offers in database -----------------------
  total_offers = @conn.exec("SELECT COUNT (*) FROM job_offers").map do |total_offers|
    @total = total_offers["count"].to_i
    puts "---------------> number of offers in db #{@total}"
  end # cette partie peut ne pas être copié ???

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
      puts "---------------> page: offers for page n° :  #{page}"

      puts "---------------> limit: nb of offers per pages, 10, 20, 50, 100 :  #{limit_given}"

      puts "---------------> bg_offers : offers offsert startint at row n° :  #{bg_offers}"
    end
  end
  #///////////////////////////// ENF OF PAGINATION ////////////////////////

  if job == nil || job == ""
    sql = ""
  else
    sql = "AND to_tsvector('french', offer_description || ' ' || title) @@ plainto_tsquery('french', '#{job}')"
  end

  requete_sql = "SELECT *, distance FROM (SELECT *, ( 6371 * acos( cos( radians( #{@lat} ) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(#{@lng}) ) + sin( radians(#{@lat}) ) * sin( radians( latitude ) ) ) ) AS distance FROM job_offers ) AS dt WHERE distance < #{@distance} #{sql} ORDER BY publication_date DESC LIMIT #{limit} OFFSET #{bg_offers} ;"

  puts "-----------------REQUETE SQL : #{requete_sql}"

  result = @conn.exec(requete_sql)
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

#conn.close
