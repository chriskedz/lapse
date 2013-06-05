require 'test_helper'

class FramesTest < Lapse::TestCase

  def test_clip_frames
    stub_request(:get, 'https://everlapse.com/v1/clips/1/frames').to_return(:status => 200, :body => "[]")
    assert_equal [], authenticated_client.clip_frames(1)
  end

  def test_create_frame
    stub_request(:post, 'https://everlapse.com/v1/clips/1/frames').to_return(:status => 200, :body => "{}")
    assert_equal Hash.new, authenticated_client.create_frame(1)
  end

  def test_accept_frame
    stub_request(:post, 'https://everlapse.com/v1/clips/1/frames/2/accept').to_return(:status => 200, :body => "{}")
    assert authenticated_client.accept_frame(1, 2)
  end

  def test_destroy_frame
    stub_request(:delete, 'https://everlapse.com/v1/clips/1/frames/2').to_return(:status => 200)
    assert authenticated_client.destroy_frame(1, 2)
  end

end
