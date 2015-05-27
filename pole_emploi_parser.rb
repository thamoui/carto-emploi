require 'open-uri'
require 'pg'

CONN = PGconn.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pole_emploi", :user=>"pole_emploi", :password=>'pole_emploi')

def document_by_url(url)
	begin
    open(url).read
  rescue
  	false
  end
  puts url
end

def not_nil(url)
  if url == nil
    false
  else
    true
  end
end

def urls
	jobs = ["Administrateur", "Administrateur base de données", "Chef de projet web", "Developpeur", "Ingenieur informatique", "Integrateur", "Securite informatique", "Testeur", "Webmaster"]
	(1..101).map do |zipcode|
		
		if zipcode < 10
			zipzero = "0#{zipcode}"
		else
			zipzero = "#{zipcode}"
		end

		jobs.map {|job| "http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_#{job}_DEPARTEMENT_#{zipzero}___P__________INDIFFERENT_________________"; job.gsub!(/\s/,'$0020')}
    
	end.flatten
end

def save_job(params)
   url = 'candidat.pole-emploi.fr/candidat/rechercheoffres/detail/' + "#{params[:id]}"
   CONN.exec("INSERT INTO parse (id, url) VALUES ('#{params[:id]}', '#{url}')")
end

def get_ids_by_document(document)
	document.scan(/detailoffre\/(.*?);/).flatten
end

urls.each do |url|
	document = document_by_url(url)

	if document 
		ids = get_ids_by_document(document)
		ids.each {|id| save_job({:id=>id})}
	end
end
