require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'nokogiri'


class BodyParser

  # attr_reader :url, :doc
  # def initialize(url)
  #   @url = url
  #   @doc = Nokogiri::HTML(open(:url))
  # end



  def get_body(url)
    url = "https://simplon2015exercices.herokuapp.com/"
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    puts res.read_body
  end

  def get_html_source(url)
    doc = Nokogiri::HTML(open(url))
  end


  #----------- PARSING METHODS -----------------------------
  #----------- THERE ARE  8 METHODS --------------------------

  # ----------------L'offre n'est plus disponible
  def offer_unavailable(url)
    doc = Nokogiri::HTML(open(url))
    message = doc.css('p[@class="first paragraph-embed"]').children.inner_text
    #return true or false
  end

  #------------------- Adresse ------------------------------
  def search_region(url)
    doc = Nokogiri::HTML(open(url))
    region_adress = doc.css('li[@itemprop="addressRegion"]').children.inner_text
    if region_adress != nil || region_adress != ""
      region_adress.gsub!(/'/, "''")
      region_adress.sub! /^\w+\s-\s/, ''
      # rajouter france pour que l'adresse soit mieux interprétée ?
      # region_adress + ", France"
    else
      region_adress =  "Information non disponible"
    end
  end

  #------------------- Département ------------------------------

  def search_dept(url)
    doc = Nokogiri::HTML(open(url))
    dpt = doc.css('li[@itemprop="addressRegion"]').children.inner_text
    if dpt != nil || region_adress != ""
      dpt = dpt[/[^ -]+/]
    else
      dpt =  "Information non disponible"
    end
  end

  #--------- Intitulé du poste ---------
  def search_title(url)
    doc = Nokogiri::HTML(open(url))
    job_title = doc.css('h4[@itemprop="title"]').children.inner_text
    if job_title != nil
      job_title.gsub(/'/, "''")
    else
      job_title =  "Information non disponible"
    end
  end

  #--------- Type de contrat ---------
  def search_employment_type(url)
    doc = Nokogiri::HTML(open(url))
    employement_type = doc.css('span[@itemprop="employmentType"]').children.inner_text
    if   employement_type != nil || employement_type != "" || employement_type.string?
      employement_type = employement_type[/[^-]+/]
      # employement_type.gsub!(/'/, "''")
      # employement_type.strip
    else
      employement_type =  "Information non disponible"
    end
  end

  #--------- Code Rome ---------
  def search_code_rome(url)
    doc = Nokogiri::HTML(open(url))
    code_rome = doc.css('p[@itemprop="occupationalCategory"]').children.inner_text
    if code_rome != nil || code_rome != ""
      code_rome.gsub!(/Métier du ROME /, "")
      code_rome[0..4]
    else
      code_rome =  "Information non disponible"
    end
  end

  def search_publication_date(url)
    doc = Nokogiri::HTML(open(url))
    publication_date = doc.css('span[@itemprop="datePosted"]').children.inner_text
  end

  def search_description_offer(url)
    doc = Nokogiri::HTML(open(url))
    description_offer = doc.css('p[@itemprop="description"]').inner_html
    if description_offer != nil || description_offer != ""
      description_offer.gsub(/'/, "''")
    else
      description_offer =  "Information non disponible"
    end
  end

  def search_company_description(url)
    doc = Nokogiri::HTML(open(url))
    company_description = doc.xpath("//div[contains(@class,'vcard')]/p/text()").collect {|node| node.text}
    company_description[0]
    if company_description[0] != nil #|| company_description[0] != ""
      company_description[0].gsub(/'/, "''")
    else
      company_description[0] =  "Information non disponible"
    end
  end

end
