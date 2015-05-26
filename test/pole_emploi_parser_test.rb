require "minitest/autorun"
require "./parser/pole_emploi_parser"
require File.expand_path '../test_helper.rb', __FILE__

class PoleEmploiParserTest < Minitest::Test

  def test_get_url
    expected = "http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_Administrateur_DEPARTEMENT_1___P__________INDIFFERENT_________________"
    assert_equal expected, document_by_url("http://candidat.pole-emploi.fr/candidat/rechercheoffres/resultats/A_Administrateur_DEPARTEMENT_1___P__________INDIFFERENT_________________")
  end

  def test_url_not_nil
    assert_equal (true), not_nil('url')
  end

  def test_id_offer
    assert_equal ([]), get_ids_by_document('document')
  end
end
