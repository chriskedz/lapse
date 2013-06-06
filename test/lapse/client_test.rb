require 'test_helper'

class ClientTest < Lapse::TestCase
  def test_initialization
    client = Lapse::Client.new(:access_token => 'asdf1234')
    assert_equal 'asdf1234', client.access_token
    assert client.authenticated?

    client = Lapse::Client.new('asdf1234')
    assert_equal 'asdf1234', client.access_token

    client = Lapse::Client.new
    refute client.authenticated?
  end

  def test_base_url
    client = Lapse::Client.new
    assert_equal 'https://everlapse.com/api/v1/', client.base_url

    client = Lapse::Client.new(:api_scheme => 'http', :api_host => 'example.com', :api_version => 42)
    assert_equal 'http://example.com/api/v42/', client.base_url

    client = Lapse::Client.new(:api_url => 'http://example.com')
    assert_equal 'http://example.com/api/v1/', client.base_url

    client = Lapse::Client.new(:api_url => 'http://localhost:3000')
    assert_equal 'http://localhost:3000/api/v1/', client.base_url

    client = Lapse::Client.new(:api_prefix => 'asd')
    assert_equal 'https://everlapse.com/asd/v1/', client.base_url
  end

  def test_ssl?
    client = Lapse::Client.new
    assert client.ssl?

    client = Lapse::Client.new(:api_scheme => 'http')
    refute client.ssl?
  end

  def test_configuration
    Lapse::Client.configure do |client|
      client.api_host = 'blah'
      client.api_scheme = 'gopher'
      client.result_format = :hash
    end

    assert_equal 'blah', Lapse::Client.new.api_host
    assert_equal 'gopher', Lapse::Client.new.api_scheme
    Lapse::Client.new.result_format

    # forcibly reset the configuration
    Lapse::Client.options = nil
  end

end
