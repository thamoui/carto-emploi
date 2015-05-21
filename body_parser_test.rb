require 'minitest/autorun'
require_relative 'body_parser'


class BodyParserTest < Minitest::Test

  def doc
   @newdoc = ::BodyParser.new
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
    expect="En premier lieu joindre des vraies  références  de site réalisés à votre  Cv Vous devrez élaborer des stratégies digitales : audits des divers sites du groupe- benchmark, identification des best-practices et rédaction des recommandationsSuivi opérationnel du déploiement Webmastering, Community ManagementSuivi et mesure de la performance des dispositifs mis en placeSerez en charge de l'optimisation SEO/SEA, comparateurs, et rédaction web (suivi et développement du référencement naturel, création et optimisation  adwords, remarketingVous aurez en charge le développement du référencement et de son optimisation.Vous piloterez les données des conversions, analyserez le trafic, réaliserez des tests de type AB, et gèrerez les newsletters.Vous pourrez également intervenir sur le CSS ou le design du site, et effectuer des mises à jours (fiches produits....)Connaissances PHP OBjet CSS, html, et Photoshop seraient un reel plusCONNAISSANCE EN DESIGN IMPERATIF"
    assert_equal expect, doc.search_description_offer(@url)
  end

  def test_6_Company_Description
    @url = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    expect = "INFO MAXune bonne culture générale et  disposez d'une bonne capacité rédactionnelleVous possédez une réelle culture web :  suivi de  l'actualité webmarketing,  présence active sur le net (blogs, réseaux sociaux et professionnels, sites internet, ...)Vous avez de tres bonnes bases en référencement naturel (fonctionnement des moteurs de recherche, notions de php et html, balises métas, quelques connaissances de techniques de référencement, Vous savez utiliser les outils Google (Analytics, etc...."
    assert_equal expect, doc.search_company_description(@url)
  end

end
