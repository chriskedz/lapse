require 'test_helper'

class UsersTest < Lapse::TestCase
  def test_authenticate
    key = 'test_key'

    stub_request(:post, 'https://everlapse.com/api/v1/authenticate').with(:body => "{\"twitter_access_token\":\"#{key}\"}").
      to_return(:status => 200, :body => "{}", :headers => {"x-access-token" => 'fake_token'})

    result = unauthenticated_client.authenticate(key)
    assert_equal Hash.new, result.user
    assert_equal 'fake_token', result.access_token
  end

  def test_me
    stub_request(:get, 'https://everlapse.com/api/v1/me').to_return(:status => 200, :body => "{}")
    assert_equal Hash.new, authenticated_client.me
  end
end
