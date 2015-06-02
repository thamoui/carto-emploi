get '/emploi' do
  # matches "GET /offres?page=1&nb_offers=10"
  content_type :json
  page = params['page'].to_i
  limit1 = params['limit'].to_i

  #----------- Counting number of all offers in database -----------------------
  total_offers = @conn.exec("SELECT COUNT (*) FROM job_offers").map do |total_offers|
    @total = total_offers["count"].to_i
    puts "---------------> number of offers in db #{@total}"
  end

  if limit1 == 0 #afficher, 10, 20 ou 50 annonces, nombre qui bouge suivant le nbre d'offers disponibles dans la BDD
    limit = 10 #afficher, 10, 20 ou 50 annonces, nombre fixe
    bg_offers = limit1
    page = 0
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> this is nb of pages availables for pagination :  #{all_pages} // if offers == 0"
  else
    limit = limit1
    all_pages = (@total.to_f / limit).ceil
    puts "---------------> this is number of pages availables for pagination #{all_pages} // if offers >0"
    puts "---------- this is limit if offers =! 0 & page >=1 #{limit}"
    bg_offers = limit1 - limit
    if page >= 1 && page <= all_pages
      bg_offers = limit1 * (page - 1)
      puts "---------------> page: offers for page n° :  #{page}"
      puts "---------------> limit: nb of offers per pages, 10, 20, 50 :  #{limit1}"

      puts "---------------> bg_offers : offers offsert startint at row n° :  #{bg_offers}"
    end
  end

#------------ ORDER BY ASC : renvoie les premiers enregistrements de la base par id_key, choisir plutôt la date de parution ou autre
  @data_job = []
  @conn.exec("SELECT * FROM job_offers ORDER BY id_key ASC LIMIT #{limit} OFFSET #{bg_offers}").map do |result|
    puts result["id_key"]
    @data_job << result
    end
  puts "number of elements in the @data_job hash #{@data_job.length}"
  @data_job.to_json
 end
