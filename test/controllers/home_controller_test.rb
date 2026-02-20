require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "renders works from database in cards and modal hooks" do
    work = Work.create!(
      title: "Neon Showreel",
      video_url: "https://example.com/demo.mp4",
      tags: "#animation #trackmake #soundeffect",
      description: "line1\nline2"
    )

    File.open(file_fixture("thumbnail.jpg")) do |file|
      work.thumbnail.attach(io: file, filename: "thumbnail.jpg", content_type: "image/jpeg")
    end

    get root_url

    assert_response :success
    assert_includes response.body, "Neon Showreel"
    assert_includes response.body, "#animation #trackmake #soundeffect"
    assert_includes response.body, "data-controller=\"video-modal\""
    assert_includes response.body, "data-action=\"video-modal#open\""
    assert_includes response.body, "data-video-modal-url-param=\"https://example.com/demo.mp4\""
    assert_includes response.body, "data-video-modal-target=\"overlay\""
  end
end
