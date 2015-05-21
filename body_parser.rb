require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'nokogiri'

class BodyParser

  #attr_reader :url

  # def initialize(url:)
  # @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
  # # #   # json = File.read(dataset)
  # # #   # @offers = JSON.parse(json, symbolize_names: true)
  # # #   # @title = title.downcase
  # # #   # @description = description.downcase
  # # #   # @work_type = work_type.downcase
  # end

  def get_body(url)
    url = "https://simplon2015exercices.herokuapp.com/"
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    puts res.read_body
  end

  # def get_body(url)
  #   url = 'http://0.0.0.0/jobseeker/offre_027FLJF.html' #apache must be started
  # end

  def search_region(url)
    #url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    doc = Nokogiri::HTML(open(url))
    region_adress = doc.css('li[@itemprop="addressRegion"]').children.inner_text

    #--> renvoie
    #<Nokogiri::XML::Element:0x3faa904f8ba0 name="li" attributes=[#<Nokogiri::XML::Attr:0x3faa904f8b28 name="itemprop" value="addressRegion">] children=[#<Nokogiri::XML::Text:0x3faa904f86b4 "67 - MUNDOLSHEIM">]>]

    #voir http://stackoverflow.com/questions/15262997/scraping-track-data-from-html
    #page.search
    #region_adress
  end

  def search_title(url)
    doc = Nokogiri::HTML(open(url))
    job_title = doc.css('h4[@itemprop="title"]').children.inner_text
  end

  def search_employment_type(url)
    doc = Nokogiri::HTML(open(url))
    employement_type = doc.css('span[@itemprop="employmentType"]').children.inner_text
  end

  def search_code_rome(url)
    doc = Nokogiri::HTML(open(url))
    code_rome = doc.css('p[@itemprop="occupationalCategory"]').children.inner_text
  end

  def search_publication_date(url)
    doc = Nokogiri::HTML(open(url))
    publication_date = doc.css('span[@itemprop="datePosted"]').children.inner_text
  end

  def search_description_offer(url)
    doc = Nokogiri::HTML(open(url))
    description_offer = doc.css('p[@itemprop="description"]').children.inner_text
  end

  def search_company_description(url)
    doc = Nokogiri::HTML(open(url))
    description_offer = doc.xpath("//div[contains(@class,'vcard')]/p/text()").inner_text
    # description_offer.inner_text[0, 8] récupération des 8 premiers caractères
  end

  # def search_name(text)
  #   text.split(" ").select{|mot| mot[0] =~ /[A-Z]/}.join(" ")
  # end
  #
  # def post_title(url)
  #   doc = Nokogiri::HTML(open(url))
  #   title = doc.css(".post-title").to_s
  #   puts
  # end

end
