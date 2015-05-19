require 'minitest/autorun'
require_relative 'url_tester'


class TestingUrlTest < Minitest::Test

  def url
  @newurl = ::TestingUrl.new
  end


  def test_1_get_url_succed
    expected = "https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF"
    assert_equal expected, url.get_html("https://candidat.pole-emploi.fr/candidat/rechercheoffres/detail/027FLJF")
  end

  def test_2_url_cant_be_nil
    assert_equal (true), url.isnot_nil('url')
  end

  def test_3_url_beggin_with_regex_https
    assert_equal (0), url.is_http('url')
  end

  def test_4_response_success_from_get_http
    assert_equal (true), url.get_response_success('url')
  end
end
