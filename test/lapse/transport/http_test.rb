require 'test_helper'

class HttpTest < Lapse::TestCase
  def test_default_mashie_format
    stub_request(:get, 'https://everlapse.com/v1/configuration').to_return(status: 200, body: "{}")
    assert_equal Hashie::Mash, Lapse.configuration.class
  end
end
