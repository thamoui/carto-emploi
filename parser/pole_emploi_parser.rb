require 'open-uri'
require 'pg'
require 'dotenv'
require_relative 'body_parser'
Dotenv.load

#----------------------- HEROKU DB CONFIG  ------------------------
if ENV['RACK_ENV'] == "production"
	db_parts = ENV['DATABASE_URL'].split(/\/|:|@/)
	CONN = PGconn.connect(host: db_parts[5], port: 5432, dbname: db_parts[7], user: db_parts[3], password: db_parts[4])
else
	#----------------------- CONNECT DATABASE LOCALHOST ----------------------
	CONN = PGconn.connect(host: "127.0.0.1", port: 5432, dbname: ENV['DATABASE_NAME'], user: ENV['DATABASE_USER_NAME'], password: ENV['DATABASE_PASSWORD'])
end

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
		puts "urls are nil"
	else
		true
	end
end

# --------------------- DEF URL FOR TEST - PARSE ONLY A FEW DATA ----------------------------
def urls
	jobs = ["Administrateur", "Administrateur base de données", "Chef de projet web", "Développeur", "Ingénieur informatique", "Intégrateur", "Sécurité informatique", "Testeur informatique", "Webmaster", "informatique", "Informaticien", "Architecte", "Responsable informatique"]
	if ARGV[0] == nil or ARGV[0] == "20" or ARGV[0].to_i > 95
		puts "Le département #{ARGV[0]} n'existe pas, veuillez tapez un ou deux numéros de département valide svp : de 1 à 19, 2A, 2B, de 21 à 95"
	else

		if  ARGV[0] == "2A" || ARGV[0] == "2B"
			if ARGV[1] == nil
				ARGV[1] = ARGV[0]
			end
			corse = [ARGV[0], ARGV[1]]
			corse.map do |zipcode|
				puts zipcode
				jobs.map {|job| job.gsub!(/\s/,'$0020'); "http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_#{job}_DEPARTEMENT_#{zipcode}___P__________INDIFFERENT_________________"}
			end.flatten

		else
			if ARGV[1] == nil
				ARGV[1] = ARGV[0]
			end
			(ARGV[0].to_i..ARGV[1].to_i).map do |zipcode|

				if zipcode < 10
					zipcode= "0#{zipcode}"
				else
					zipcode = "#{zipcode}"
				end

				jobs.map {|job| job.gsub!(/\s/,'$0020'); "http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_#{job}_DEPARTEMENT_#{zipcode}___P__________INDIFFERENT_________________"}
			end.flatten
		end
	end
end


def save_job(params)
	url = 'http://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/' + "#{params[:id]}"
	puts "------this is url parsed from search result for dpt : #{url}"
	CONN.exec("INSERT INTO parse (url, id) SELECT '#{url}', '#{params[:id]}' WHERE NOT EXISTS (select id from parse WHERE id = '#{params[:id]}')")
end

#----------------- Parse les urls métiers par départements pour récupérer l'id ----------
def get_ids_by_document(document)
	document.scan(/detailoffre\/(.*?);/).flatten
end

def doc
	::BodyParser.new
end

#########
# MAIN #

if urls != nil

	urls.each do |url|
		puts "------------------------------ this is url #{url} -----------------------------------"
		document = document_by_url(url)

		if document && doc.search_region(url) == doc.search_region(url).upcase
			ids = get_ids_by_document(document)
			ids.each {|id| save_job({:id=>id})}
			puts "//////////// URL SAVED IN DB ////////////////////"
		end
	end
end
#conn.close
