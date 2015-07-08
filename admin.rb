
# --------------- gestion des donn�es en mode objet gr�ce � active records
class Job_list < ActiveRecord::Base
end

class Job_offer < ActiveRecord::Base
end


# --------------- /admin : interface d'administration de l'api
get '/admin' do
  @jobs_list = Job_list.all() #execute la requête SELECT "job_lists".* FROM "job_lists"

  erb :admin
end

get '/admin/metiers' do
  @jobs_list = Job_list.all()
  #redirect "/admin/new_metier" if @jobs_list.empty?
  erb :metiers
end

post '/admin/new_metier' do
  @job_list = Job_list.new(params[:job_list])
  if @job_list.save
    redirect "admin/metier/#{@job_list.id}"
  else
    erb :metiers
  end
end

get "admin/metier/:id" do
  @jobs_list = Job_list.find_by_id(params[:id])
  erb :metiers
end


get '/admin/new_metier' do
  erb :new_metier
end

get "/issue/:id" do
  @job_list = Job_list.find_by_id(params[:id])
  erb :metiers
end


get '/admin/offres' do
  @job_offers = Job_offer.last(10)
  erb :offres
end
#j'ai bien la requête SELECT  "job_offers".* FROM "job_offers"  ORDER BY "job_offers"."id_key" DESC LIMIT 5
