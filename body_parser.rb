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

  def analyse(url)
    doc = Nokogiri::HTML(open(url))
    doc.css(".post-entry").to_s #dépend de la source car analyse le dom
  end

  def search_region(url)
    url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    doc = Nokogiri::HTML(open(url))
    region_adress = doc.css('li[@itemprop="addressRegion"]').children.inner_text
  
    #--> renvoie
    #<Nokogiri::XML::Element:0x3faa904f8ba0 name="li" attributes=[#<Nokogiri::XML::Attr:0x3faa904f8b28 name="itemprop" value="addressRegion">] children=[#<Nokogiri::XML::Text:0x3faa904f86b4 "67 - MUNDOLSHEIM">]>]

    #voir http://stackoverflow.com/questions/15262997/scraping-track-data-from-html
    #page.search
    region_adress

  end

  def search_name(text)
    text.split(" ").select{|mot| mot[0] =~ /[A-Z]/}.join(" ")
  end

  def post_title(url)
    doc = Nokogiri::HTML(open(url))
    title = doc.css(".post-title").to_s
    puts
  end

end
