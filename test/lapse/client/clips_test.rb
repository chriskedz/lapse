require 'test_helper'

class ClipsTest < Lapse::TestCase

  def test_all_clips
    stub_request(:get, 'https://everlapse.com/api/v1/clips').to_return(:status => 200, :body => "[]")
    assert_equal [], authenticated_client.all_clips
  end

  def test_featured_clips
    stub_request(:get, 'https://everlapse.com/api/v1/clips/featured').to_return(:status => 200, :body => "[]")
    assert_equal [], authenticated_client.featured_clips
  end

  def test_create_clip
    stub_request(:post, 'https://everlapse.com/api/v1/clips').to_return(:status => 200, :body => "{}")
    assert_equal Hash.new, authenticated_client.create_clip
  end

  def test_publish_clip
    stub_request(:post, 'https://everlapse.com/api/v1/clips/1/publish').to_return(:status => 200, :body => "{}")
    assert_equal Hash.new, authenticated_client.publish_clip(1)
  end

  def test_destroy_clip
    stub_request(:delete, 'https://everlapse.com/api/v1/clips/1').to_return(:status => 200)
    assert authenticated_client.destroy_clip(1)
  end

end
