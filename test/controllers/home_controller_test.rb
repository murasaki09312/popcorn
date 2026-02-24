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
    assert_includes response.body, "aria-controls=\"works-video-modal\""
    assert_includes response.body, "aria-expanded=\"false\""
    assert_includes response.body, "role=\"dialog\""
    assert_includes response.body, "id=\"works-video-modal\""
    assert_includes response.body, "aria-hidden=\"true\""
    assert_includes response.body, "/rails/active_storage/blobs/redirect/"
    assert_not_includes response.body, "/rails/active_storage/representations/redirect/"
  end

  test "renders site settings values on top page" do
    setting = SiteSetting.instance
    setting.update!(
      about_text: "about line one\nabout line two",
      contact_text: "LINEからご相談ください。",
      instagram_url: "https://www.instagram.com/popcorn",
      youtube_url: "https://www.youtube.com/@popcorn",
      line_url: "https://line.me/ti/p/example"
    )

    get root_url

    assert_response :success
    assert_includes response.body, "about line one"
    assert_includes response.body, "LINEからご相談ください。"
    assert_includes response.body, "https://www.instagram.com/popcorn"
    assert_includes response.body, "https://www.youtube.com/@popcorn"
    assert_includes response.body, "https://line.me/ti/p/example"
  end
end
