require 'sinatra'
require 'shotgun'
require 'json'
require 'pg'


configure do
  set :conn, PG.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pole_emploi", :user=>"pole_emploi", :password=>'pole_emploi')
end

before do
  @conn = settings.conn
end

get '/' do
  send_file 'views/index.html'
end

#/--------------/emploi : renvoi un tableau JSON avec tous les emplois
#------- renvoie les 10 dernières ajoutées

get '/test' do
  content_type :json
  @data_job = []
  @conn.exec("SELECT * FROM job_offers ORDER BY id_key ASC LIMIT 9 OFFSET 0").map do |result|
    result = result
    @data_job << result
  end
 @data_job.to_json
end

get '/emploi' do
  content_type :json
  # matches "GET /offres?paginate=1&nb_offers=10"
  paginate = params['paginate'].to_i
  offers = params['offers'].to_i

  #----------- Counting number of all offers in database -----------------------
  total_offers = @conn.exec("SELECT COUNT (*) FROM job_offers").map do |total_offers|
    @total = total_offers["count"].to_i
    puts "---------------> number of offers in db #{@total}"
  end
    paginate_all = (@total.to_f / offers).ceil
    puts "---------------> this is number of pages availables for pagination #{paginate_all}"


  if offers == 0 #si on ne met pas paginate, c egal a 0
    limit = 10 #afficher, 10, 20 ou 500 annonces
    bg_offers = offers
    paginate = 0
  else
    #ex offers = 10 & paginate = 2
    limit = offers #10
    bg_offers = offers - limit
    if paginate >= 1 && paginate <= paginate_all
      bg_offers = offers * (paginate - 1)
      puts "---------------> bg_offers : offers offsert startint at row n° :  #{bg_offers}"
    end

  end

#------------ ORDER BY ASC : renvoie dernier enregistrements de la base, choisir plutôt la date de parution ou autre
  @data_job = []
  @conn.exec("SELECT * FROM job_offers ORDER BY id_key ASC LIMIT #{limit} OFFSET #{bg_offers}").map do |result|
    puts result["id_key"]
    @data_job << result

    end
  puts "number of elements in the @data_job hash #{@data_job.length}"

  @data_job.to_json

 end

#--------------- /emploi/ID : renvoi l'emploi via son id
get '/offres/:id' do
  id = ''
  id << params[:id]
  puts "---------------this is id #{id}"
  @data_job = []
  @conn.exec("SELECT * FROM job_offers WHERE offer_id='#{id}' ").map do |result|
  @data_job << result
  end
  @data_job.to_json
end

#--------------   /search/S : renvoi un tableau JSON avec les emplois correspondant à la recherche

get '/search/:job' do
  offer = ''
  offer << params[:job]
  puts "---------------this is job searched #{offer}"
  @data_job = []
  result = @conn.exec("SELECT title || '},{' || code_rome FROM job_offers WHERE to_tsvector('french', code_rome || ' ' || title) @@ to_tsquery('french', '#{offer}');")
    result.map do |result|
      puts "-----this is result #{result}"
    @data_job << result
  end
  if @data_job == []
     "Aucun emploi ne correspond à votre recherche"
  else
        @data_job.to_json
  end
end

#--------------   /geosearch/LAT,LNG : renvoi les emplois aux alentours

get '/geosearch/:lat,:lng' do
  "renvoi les emplois aux alentours"

  @lat = params[:lat]
  @lng = params[:lng]
  @distance = 5
  @data_job = []

  puts @lat
  puts @lng

  #TESTER AVEC CES VALEURS POUR EVRY
  # @lat = 48.629828
  # @lng = 2.441782

  result = @conn.exec("select id_key, distance from (select id_key, ( 6371 * acos( cos( radians( #{@lat} ) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(#{@lng}) ) + sin( radians(#{@lat}) ) * sin( radians( latitude ) ) ) ) as distance from job_offers ) as dt where distance < #{@distance};")
result.map do |result|
  puts "-----this is result #{result}"
    @data_job << result

    if @data_job == []
       "Aucun emploi ne correspond à votre recherche"
    else
          @data_job.to_json
    end
  end
end
