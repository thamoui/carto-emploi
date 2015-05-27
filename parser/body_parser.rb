require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'nokogiri'

class BodyParser

  # attr_reader :url, :doc
  #
  #
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

  def search_region(url)
    #url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    doc = Nokogiri::HTML(open(url))
    region_adress = doc.css('li[@itemprop="addressRegion"]').children.inner_text
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
    description_offer = doc.css('p[@itemprop="description"]').inner_html
  end

  def search_company_description(url)
    doc = Nokogiri::HTML(open(url))
    description_offer = doc.xpath("//div[contains(@class,'vcard')]/p/text()").collect {|node| node.text}
    description_offer[0]
  end

end
