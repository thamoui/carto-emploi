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
get '/emploi/:paginate' do
    content_type :json
  @paginate = params[:paginate]
  @data_job = []
  @conn.exec("SELECT * FROM job_offers ORDER BY id_key DESC LIMIT #{@paginate}").map do |result|
    result = result
    @data_job << result
  end
 @data_job.to_json
end

#--------------- /emploi/ID : renvoi l'emploi via son id
get '/emploi/:id' do
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

  # @lat = 48.629828
  # @lng = 2.441782

  # result = @conn.exec("SELECT region_adress, ( 6371 * acos( cos( radians(51.8391) ) * cos( radians( #{lat} ) ) * cos( radians( #{lng} ) - radians(4.6265) ) + sin( radians(51.8391) ) * sin( radians( latitude ) ) ) ) AS distance FROM job_offers HAVING distance < 25 ORDER BY region_adress asc;")
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
