require 'minitest/autorun'
require_relative '../parser/body_parser'

require File.expand_path '../test_helper.rb', __FILE__


class BodyParserTest < Minitest::Test


  # def initialize(url)
  #   @url = url
  # end
    # def get_body(url)
    #   url = 'http://0.0.0.0/jobseeker/offre_027FLJF.html' #apache must be started
    # end

  #Aller voir ce github pour voir comment refactorer ses tests : https://github.com/seattlerb/minitest 

  def doc
   @newdoc = ::BodyParser.new()
  end

  def test_1_find_region
    expected = "75 - PARIS 16E  ARRONDISSEMENT"
    assert_equal expected, doc.search_region("https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF")
  end

  def test_2_search_job_title
    expect = "Webmaster animateur / animatrice"
    assert_equal expect, doc.search_title("https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF")
  end

  def test_2_search_employment_type
    expect = "Contrat à durée indéterminée\n"
    assert_equal expect, doc.search_employment_type("https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF")
  end

  def test_3_find_code_rome
    expect = "Métier du ROME E1101 -\nAnimation de site multimédia"
    assert_equal expect, doc.search_code_rome("https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF")
  end

  def test_4_find_publication_code
    @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    expect ="21/05/2015"
    assert_equal expect, doc.search_publication_date(@url)
  end

  def test_5_Job_Offer_Description
    @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    expect = "En premier lieu joindre des vraies  références  de site réalisés à votre  Cv <br><br>Vous devrez élaborer des stratégies digitales : audits des divers sites du groupe<br>- benchmark, identification des best-practices et rédaction des recommandations<br>Suivi opérationnel du déploiement <br>Webmastering, Community Management<br>Suivi et mesure de la performance des dispositifs mis en place<br>Serez en charge de l'optimisation SEO/SEA, comparateurs, et rédaction web (suivi et développement du référencement naturel, création et optimisation  adwords, remarketing<br>Vous aurez en charge le développement du référencement et de son optimisation.<br>Vous piloterez les données des conversions, analyserez le trafic, réaliserez des tests de type AB, et gèrerez les newsletters.<br>Vous pourrez également intervenir sur le CSS ou le design du site, et effectuer des mises à jours (fiches produits....)<br>Connaissances PHP OBjet CSS, html, et Photoshop seraient un reel plus<br>CONNAISSANCE EN DESIGN IMPERATIF"
    assert_equal expect, doc.search_description_offer(@url)
  end

  def test_6_Company_Description
    @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    expect = "INFO MAX"
    assert_equal expect, doc.search_company_description(@url)
  end

end
