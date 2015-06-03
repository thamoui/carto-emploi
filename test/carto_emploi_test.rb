require 'minitest/autorun'
require_relative '../carto_emploi'

require File.expand_path '../test_helper.rb', __FILE__


class BodyParserTest < Minitest::Test
  #
  # def test_Paginate2_For_50_offers_limit
  #   #88 offres, 50 offres, page 2
  #   expected = "38"
  #   assert_equal expected, doc.search_region(url)
  # end


  def test_query_contains_empty_space
    expected ="http://0.0.0.0:9393/search/administrateur%20de%20base%20de%20donn%C3%A9es"
  end
end
