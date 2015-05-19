require 'minitest/autorun'
require_relative 'body_parser'


class BodyParserTest < Minitest::Test

  def doc
    @newdoc = ::BodyParser.new
  end

  def test_1_find_region
    expected = "75 - PARIS 16E  ARRONDISSEMENT"
    assert_equal expected, doc.search_region('url')
  end

end
