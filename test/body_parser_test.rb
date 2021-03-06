require 'minitest/autorun'
require_relative '../parser/body_parser'

require File.expand_path '../test_helper.rb', __FILE__


class BodyParserTest < Minitest::Test

  #Aller voir ce github pour voir comment refactorer ses tests : https://github.com/seattlerb/minitest

  print ">>>> HEY !!!!!! Start a server with $ruby -run -e httpd . -p 8000 --------------"

  def doc
    ::BodyParser.new
  end

  def test_1_find_region
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    expected = "75 , PARIS 16E  ARRONDISSEMENT, FRANCE"
    assert_equal expected, doc.search_region(url)
  end

  def test_2_search_job_title
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    expect = "Webmaster animateur / animatrice"
    assert_equal expect, doc.search_title(url)
  end

  def test_2_search_employment_type
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"

    #expect = "Contrat à durée indéterminée\n"
    #"Contrat à durée déterminée - 6 Mois"
    expect = "Contrat à durée indéterminée"
    assert_equal expect, doc.search_employment_type(url)
  end

  def test_3_find_code_rome
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    #expect = "Métier du ROME E1101 -\nAnimation de site multimédia"
    expect = "E1101"
    assert_equal expect, doc.search_code_rome(url)
  end

  def test_4_find_publication_date
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    expect ="11/05/2015"
    assert_equal expect, doc.search_publication_date(url)
  end

  def test_5_job_offers_Description
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    expect = "En premier lieu joindre des vraies  références  de site réalisés à votre  Cv <br><br>Vous devrez élaborer des stratégies digitales : audits des divers sites du groupe<br>- benchmark, identification des best-practices et rédaction des recommandations<br>Suivi opérationnel du déploiement <br>Webmastering, Community Management<br>Suivi et mesure de la performance des dispositifs mis en place<br>Serez en charge de l''optimisation SEO/SEA, comparateurs, et rédaction web (suivi et développement du référencement naturel, création et optimisation  adwords, remarketing<br>Vous aurez en charge le développement du référencement et de son optimisation.<br>Vous piloterez les données des conversions, analyserez le trafic, réaliserez des tests de type AB, et gèrerez les newsletters.<br>Vous pourrez également intervenir sur le CSS ou le design du site, et effectuer des mises à jours (fiches produits....)<br>Connaissances PHP OBjet CSS, html, et Photoshop seraient un reel plus<br>CONNAISSANCE EN DESIGN IMPERATIF"
    assert_equal expect, doc.search_description_offer(url)
  end

  def test_6_Company_Description
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    expect = "INFO MAX"
    assert_equal expect, doc.search_company_description(url)
  end

  def test_7_Offre_Non_Disponible
    url = "http://0.0.0.0:8000/test/offre_non_disponible.html"
    assert_equal true, doc.offer_unavailable(url)
  end

  def test_8_Paris_dep_devient_ville
    url = "http://0.0.0.0:8000/test/offre_test_paris_dpt.html"
    expect = "75 , PARIS , FRANCE"
    assert_equal expect, doc.search_region(url)
  end

  def test_9_Est_bien_une_ville
    url = "http://0.0.0.0:8000/test/offre_test_027FLJF.html"
    assert_equal true, doc.check_is_a_city(url)
  end

end
