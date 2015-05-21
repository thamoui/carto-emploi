require 'net/http'
require 'pg'

conn = PGconn.connect(:hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"pole_emploi", :user=>"pole_emploi", :password=>'pole_emploi')
query_result  = conn.exec('SELECT * FROM parse')

jobs = ["developpeur", "webmaster"]
  
jobs.each do |job| 

  (1..101).each do |zipcode| 
  
    source = Net::HTTP.get('candidat.pole-emploi.fr', '/candidat/rechercheoffres/resultats/A_' + "#{job}" + '_DEPARTEMENT_' + "#{zipcode}" + '___P__________INDIFFERENT_________________')
   
    ids = source.scan(/detailoffre\/(.*?);/).flatten

    ids.each do |id|
      conn.exec("INSERT INTO parse (id) VALUES ('#{id}')")

      url = 'candidat.pole-emploi.fr/candidat/rechercheoffres/detail/' + "#{id}"
      conn.exec("INSERT INTO parse (id, url) VALUES ('#{id}', '#{url}')")
    end
  end
end



