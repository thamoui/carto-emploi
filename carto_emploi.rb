require 'sinatra'
#require 'shotgun'
require 'json'
require 'pg'
require 'dotenv'
Dotenv.load

# FOR HEROKU
  configure { set :server, :puma }
  set :public_folder, 'public'

#----------------------- LOCALHOST DB CONFIG  ------------------------
# @hostaddr = "127.0.0.1"
# @port = 5432
# @dbname = "pole_emploi"
# @user = "pole_emploi"
# @password = "pole_emploi"

# configure do
#   set :conn, PG.connect(:hostaddr=>@hostaddr, :port=>@port, :dbname=>@dbname, :user=>@user, :password=>@password)
# end

#----------------------- HEROKU DB CONFIG  ------------------------
  db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
  username = db_parts[3]
  password = db_parts[4]
  host = db_parts[5]
  db = db_parts[7]

  configure do
  set :conn, PG.connect(:host =>  host, :dbname => db, :user=> username, :password=> password)
  end

before do
  @conn = settings.conn
end

get '/' do
  send_file 'frontend/index.html'
end
#--------------- /emploi/ID : renvoi l'emploi via son id
get '/emploi/:id' do
  content_type :json
  id = ''
  id << params[:id]
  puts "---------------this is id #{id}"
  @data_job = []
  @conn.exec("SELECT * FROM job_offers WHERE offer_id='#{id}' ").map do |result|
  @data_job << result
  end
  @data_job.to_json
end
#/--------------/emploi : renvoi un tableau JSON avec tous les emplois
#------- renvoie les 10 dernières ajoutées
get '/emploi' do
  # matches "GET /emploi?p=1&limit=10"
  content_type :json
  page = params['p'].to_i
  limit_given = params['limit'].to_i


  #////////////////////////////// PAGINATION ///////////////////////
  #----------- Counting number of all offers in database -----------------------
  total_offers = @conn.exec("SELECT COUNT (*) FROM job_offers").map do |total_offers|
    @total = total_offers["count"].to_i
    puts "---------------> number of offers in db #{@total}"
  end

  if limit_given == 0 #afficher, 10, 20 ou 50 annonces, nombre qui bouge suivant le nbre d'offers disponibles dans la BDD
    limit = 100 #afficher, 10, 20 ou 50 annonces, nombre fixe
    bg_offers = limit_given
    page = 0
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> this is nb of pages availables for pagination :  #{all_pages} // if offers == 0"
  else
    limit = limit_given
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> this is number of pages availables for pagination #{all_pages} // if offers >0"
    puts "---------- this is limit if offers =! 0 & page >=1 #{limit}"
    bg_offers = limit_given - limit
    if page >= 1 && page <= all_pages
      bg_offers = limit_given * (page - 1)
      puts "---------------> page: offers for page n° :  #{page}"
      puts "---------------> limit: nb of offers per pages, 10, 20, 50, 100 :  #{limit_given}"

      puts "---------------> bg_offers : offers offsert startint at row n° :  #{bg_offers}"
    end
  end
  #///////////////////////////// ENF OF PAGINATION ////////////////////////

#------------ ORDER BY ASC : renvoie les premiers enregistrements de la base par id_key, choisir plutôt la date de parution ou autre
  @data_job = []
  @conn.exec("SELECT * FROM job_offers ORDER BY id_key ASC LIMIT #{limit} OFFSET #{bg_offers}").map do |result|
    puts result["id_key"]
    @data_job << result
    end
  puts "number of elements in the @data_job hash #{@data_job.length}"
  @data_job.to_json
 end

#--------------   /search/S : renvoi un tableau JSON avec les emplois correspondant à la recherche
get '/search/:text' do
  content_type :json
  #offer = ''
  job = params[:text]
  page = params['p'].to_i
  limit_given = params['limit'].to_i


  puts "---------------- NEW SEARCH -------------------------"
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

  @data_job = [] #faut-il définir ça au début du fichier ? Est commun à chaque méthode

  result = @conn.exec("SELECT * FROM job_offers WHERE to_tsvector('french', offer_description || ' ' || title) @@ plainto_tsquery('french', '#{job}') ORDER BY id_key ASC LIMIT #{limit} OFFSET #{bg_offers}; ")

    result.map do |result|
    puts "---- #{result["id_key"]} // #{result["offer_id"]} : #{result["title"]}"
    @data_job << result

  end
  if @data_job == []
     "Aucun emploi ne correspond à votre recherche. Veuillez préciser votre recherche : Webmaster, testeur, administrateur"
  else
    @data_job.to_json
  end
end

#--------------   /geosearch/LAT,LNG : renvoi les emplois aux alentours

get '/geosearch/:lat,:lng' do
  #geosearch/48.86833,2.66833?p=42&limit=42&text=développeur

  #TESTER AVEC CES VALEURS POUR EVRY
  # @lat = 48.629828
  # @lng = 2.441782

  content_type :json


  @lat = params[:lat]
  @lng = params[:lng]

  job = params['text']
  @distance = params['d']

  if @distance == nil || ""
    @distance = 50
  end

  page = params['p'].to_i
  limit_given = params['limit'].to_i

  @data_job = []

  # puts @lat
  # puts @lng
  # puts "this is DISTANCE WHEN EMPTY #{@distance.class}"

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

if job == nil || ""
  sql = ""
else
  sql = "AND to_tsvector('french', offer_description || ' ' || title) @@ plainto_tsquery('french', '#{job}')"
end

  result = @conn.exec("SELECT *, distance FROM (SELECT *, ( 6371 * acos( cos( radians( #{@lat} ) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(#{@lng}) ) + sin( radians(#{@lat}) ) * sin( radians( latitude ) ) ) ) AS distance FROM job_offers ) AS dt WHERE distance < #{@distance} #{sql} ORDER BY publication_date DESC LIMIT #{limit} OFFSET #{bg_offers} ;")
  result.map do |data|
  puts "---- #{data["publication_date"]}  //  #{data["id_key"]} // #{data["offer_id"]} : #{data["title"]}"
  @data_job << data


  end


  if @data_job == []
     "Aucun emploi ne correspond à votre recherche"
  else
        @data_job.to_json
  end
end
