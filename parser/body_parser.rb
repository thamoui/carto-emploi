require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'nokogiri'


class BodyParser

  #A quoi sert la fonction ci-dessous ? C'était pour vérifier que le fichier html/url existe bien
  def get_body(url)
    url = "https://simplon2015exercices.herokuapp.com/"
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    puts res.read_body
  end

  def get_source(url)
    Nokogiri::HTML(open(url))
  end

  #----------- PARSING METHODS ------------------------------

  # ----------------L'offre n'est plus disponible -----------
  def offer_unavailable(url)
    get_source(url).css('p[@class="first paragraph-embed"]').children.inner_text == "L'offre que vous souhaitez consulter n'est plus disponible."
    #return true si l'offre n'est plus disponible
  end

  #------------------- Adresse ------------------------------
  def search_region(url)
    region_adress = get_source(url).css('li[@itemprop="addressRegion"]').children.inner_text
    if region_adress != nil || region_adress != ""
      #region_adress.gsub(/'/, "''")
      ["PARIS", "LYON", "MARSEILLE"].each do |city|
        if region_adress.include? city #mais ne contient pas le mot ARRONDISSEMENT
          if region_adress.include? "ARRONDISSEMENT"
            region_adress
          else
            region_adress = region_adress + ' ARRONDISSEMENT'
          end
        end
      end

      if region_adress == "75 - Paris (Dept.)"
        region_adress.gsub!("(Dept.)", "").upcase!
      end

      region_adress = region_adress.gsub(/['-]/, "'"=> "''", '-' => ',') + ", FRANCE"

    else
      "Information non disponible"
    end

  end


  # ------------------- Vérifie si on a bien une ville --------------------
  # --- Les villes sont en majuscule --------------------------------------


  def check_is_a_city(url)
    city = get_source(url).css('li[@itemprop="addressRegion"]').children.inner_text
    city == city.upcase

    #retourne true
  end

  #------------------- Ville------------------------------
  def search_city(url)
    city = get_source(url).css('li[@itemprop="addressRegion"]').children.inner_text
    if  (city =~ /[0-9](.*)/) == nil
      city
    elsif city != nil || city != ""
      # dpt =~ /[0-9]/
      #ça bugge s'il n'y a pas de numéro de département avec un tiret
      city.gsub!(/'/, "''")
      city.sub! /^\w+\s-\s/, '' #renvoir Paris si adress est 75 - Paris

    else
      "Information non disponible"
    end
  end

  #------------------- Département ------------------------------
  def search_dept(url)
    dpt = get_source(url).css('li[@itemprop="addressRegion"]').children.inner_text
    # attention le lieu de travail ne contient pas de numéro de département parfois comme France ou Pays de la loire
    if dpt != nil || region_adress != ""
      dpt = dpt[/[^ -]+/]
    else
      dpt =  "Information non disponible"
    end
  end

  #--------- Intitulé du poste ---------
  def search_title(url)
    job_title = get_source(url).css('h4[@itemprop="title"]').children.inner_text
    if job_title != nil
      job_title.gsub(/'/, "''")
    else
      job_title =  "Information non disponible"
    end
  end

  #--------- Type de contrat ---------
  def search_employment_type(url)
    employement_type = get_source(url).css('span[@itemprop="employmentType"]').children.inner_text
    if   employement_type != nil || employement_type != "" || employement_type.string?
      employement_type[/[^-]+/].strip
    else
      "Information non disponible"
    end
  end

  #--------- Code Rome ---------
  def search_code_rome(url)
    code_rome = get_source(url).css('p[@itemprop="occupationalCategory"]').children.inner_text
    if code_rome != nil || code_rome != ""
      code_rome.gsub!(/Métier du ROME /, "")[0..4]
    else
      code_rome =  "Information non disponible"
    end
  end

  #------------ Vérifie si code rome est bien dans la liste des métiers
  def check_code_rome(url)
    code_rome = get_source(url).css('p[@itemprop="occupationalCategory"]').children.inner_text
    if code_rome != nil || code_rome != ""
      code_rome = code_rome.gsub(/Métier du ROME /, "")[0..4]
      code_rome_info = ["M1801", "M1802", "M1803", "M1804", "M1805", "M1806", "M1810", "I1401", "H1208", "E1101", "E1104", "E1205", "E1402"]
      code_rome_info.include? code_rome
    else
      code_rome =  "Information non disponible"
    end

  end
  #----------- Date de publication -------
  def search_publication_date(url)
    get_source(url).css('span[@itemprop="datePosted"]').children.inner_text
  end

  #----------- Description de l'offre -----------
  def search_description_offer(url)
    description_offer = get_source(url).css('p[@itemprop="description"]').inner_html
    description_offer.strip
    if description_offer != nil || description_offer != ""
      description_offer.gsub(/'/, "''")
    else
      description_offer =  "Information non disponible"
    end
  end

  # ----------- Nom de l'entreprise -------------
  def search_company_description(url)
    company_description = get_source(url).xpath("//div[contains(@class,'vcard')]/p/text()").collect {|node| node.text}
    company_description[0]
    if company_description[0] != nil #|| company_description[0] != ""
      company_description[0].gsub(/'/, "''").strip
    else
      company_description[0] =  "Information non disponible"
    end
  end
end
