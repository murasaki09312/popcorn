require "test_helper"

class WorkTest < ActiveSupport::TestCase
  test "requires a title" do
    work = Work.new(video_url: "https://example.com/video", tags: "#animation", description: "desc")

    assert_not work.valid?
    assert_includes work.errors[:title], "can't be blank"
  end
end
