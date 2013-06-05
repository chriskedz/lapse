require 'test_helper'

class LapseTest < Lapse::TestCase
  def test_respond_to
    assert Lapse.respond_to?(:new, true)
  end

  def test_new
    assert_equal Lapse.new.class, Lapse::Client
  end
end
