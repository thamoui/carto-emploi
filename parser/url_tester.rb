require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'

#http://ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI.html

class TestingUrl
  attr_reader :url

  # def initialize(url:)
  #   @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
  #   # json = File.read(dataset)
  #   # @offers = JSON.parse(json, symbolize_names: true)
  #   # @title = title.downcase
  #   # @description = description.downcase
  #   # @work_type = work_type.downcase
  # end

  def get_html(url)
    #url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
  end

  def isnot_nil(url)
    if url == nil
      false
    else
      true
    end
  end

  def is_http(url)
    url = "https://simplon2015exercices.herokuapp.com/"
    url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    # url.scan(URI.regexp)
    #   => [["https", nil, nil, "simplon2015exercices.herokuapp.com", nil, nil, "/", nil, nil]]
  end

  def get_response_success(url)
    url = "https://simplon2015exercices.herokuapp.com/"
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    res.kind_of? Net::HTTPSuccess

    #  #renvoie true/false si y'a du 200 dedans
    #  -- sinon on peut faire aussi :
    #  open("https://simplon2015exercices.herokuapp.com/") do |f|
    #  puts f.base_uri #=> http://www.example.org
    #  puts f.status #=> ["200", "OK"]
    #  end
  end

end
