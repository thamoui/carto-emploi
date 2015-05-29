require 'open-uri'
require 'pg'

#----------------------- DB CONFIG  ------------------------
@hostaddr = "127.0.0.1"
@port = 5432
@dbname = "pole_emploi"
@user = "pole_emploi"
@password = "pole_emploi"

CONN = PGconn.connect(:hostaddr=>@hostaddr, :port=>@port, :dbname=>@dbname, :user=>@user, :password=>@password)

def document_by_url(url)
	begin
    open(url).read
  rescue
  	false
  end
end

def not_nil(url)
  if url == nil
    false
  else
    true
  end
end

# --------------------- DEF URL FOR TEST - PARSE ONLY A FEW DATA ----------------------------
def urls
	jobs = ["Administrateur", "Administrateur base de données", "Chef de projet web", "Développeur", "Ingénieur informatique", "Intégrateur", "Sécurité informatique", "Testeur", "Webmaster"]
	(91..95).map do |zipcode|

		if zipcode < 10
			zipzero = "0#{zipcode}"
		else
			zipzero = "#{zipcode}"
		end

		jobs.map {|job| job.gsub!(/\s/,'$0020'); "http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_#{job}_DEPARTEMENT_#{zipzero}___P__________INDIFFERENT_________________"}


	end.flatten
end

def save_job(params)
   url = 'http://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/' + "#{params[:id]}"
	puts "------this is url : #{url}"
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
