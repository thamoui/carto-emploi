require 'sinatra/base'

# ------------------------ For Developpement env :


# --------------- gestion des donnees en mode objet grace a active records
class Job_list < ActiveRecord::Base
end

class Job_offer < ActiveRecord::Base
end


class LoginScreen < Sinatra::Base
  get '/admin/login' do
    erb :login
  end

  post '/admin/login' do
    if params['name'] == ENV['ADMIN_NAME'] && params['password'] == ENV['ADMIN_PASSWORD']
      session['user_name'] = params['name']
      puts "POST ADMIN LOGIN : this is session value #{session['user_name']}"
      erb :admin
    else
      redirect '/admin/login'
    end
  end
end

#middleware will run before filters
use LoginScreen


before '/admin/*' do
  unless session['user_name']
    puts "BEFORE DO session user name #{session['user_name']}"
    halt "BEFORE DO message : Veuillez vous connecter <a href='/admin/login'>login</a>."
  end
end


# --------------- /admin : interface d'administration de l'api
get '/admin' do
  halt "Veuillez vous connecter <a href='/admin/login'>login</a>."
end

get '/admin/logout' do
  session.clear
  redirect "/"
end

get '/admin/metiers' do
  @jobs_list = Job_list.all()  #execute la requête SELECT "job_lists".* FROM "job_lists"
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

get '/admin/offres' do
  @job_offers = Job_offer.order('id_key DESC').limit(5)
  erb :offres
end
#j'ai bien la requête SELECT  "job_offers".* FROM "job_offers"  ORDER BY "job_offers"."id_key" DESC LIMIT 5


get '/admin/stats' do
  @jobs_list = Job_list.all()
  @last_offer = Job_list.order('created_at DESC').limit(5)
  erb :stats
end
