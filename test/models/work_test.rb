require "test_helper"

class WorkTest < ActiveSupport::TestCase
  test "requires a title" do
    work = Work.new(video_url: "https://example.com/video", tags: "#animation", description: "desc")

    assert_not work.valid?
    assert_includes work.errors[:title], "can't be blank"
  end

  test "allows http and https video_url" do
    work = Work.new(title: "Sample", video_url: "https://example.com/video")
    assert work.valid?

    work.video_url = "http://example.com/video"
    assert work.valid?
  end

  test "rejects non-http(s) video_url" do
    work = Work.new(title: "Sample", video_url: "javascript:alert(1)")

    assert_not work.valid?
    assert_includes work.errors[:video_url], "must be a valid HTTP or HTTPS URL"
  end
end
