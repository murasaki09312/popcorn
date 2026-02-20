require "test_helper"

class Admin::WorksManagementTest < ActionDispatch::IntegrationTest
  setup do
    User.where(email_address: "admin@example.com").delete_all
    @user = User.create!(email_address: "admin@example.com", password: "password")
  end

  test "redirects unauthenticated users to sign-in page" do
    get admin_works_url

    assert_redirected_to new_session_url
  end

  test "authenticated user can access works index" do
    sign_in_as(@user)

    get admin_works_url

    assert_response :success
  end

  test "authenticated user can create update and delete a work with thumbnail" do
    sign_in_as(@user)

    assert_difference("Work.count", 1) do
      post admin_works_url, params: {
        work: {
          title: "Phase 2 Work",
          video_url: "https://example.com/video",
          tags: "#animation #trackmake",
          description: "sample description",
          thumbnail: fixture_file_upload("thumbnail.jpg", "image/jpeg")
        }
      }
    end

    work = Work.order(:created_at).last
    assert_redirected_to admin_work_url(work)
    assert_equal "Phase 2 Work", work.reload.title
    assert work.thumbnail.attached?

    patch admin_work_url(work), params: {
      work: {
        title: "Updated Work",
        video_url: "https://example.com/new_video",
        tags: "#updated",
        description: "updated description"
      }
    }

    assert_redirected_to admin_work_url(work)
    assert_equal "Updated Work", work.reload.title
    assert_equal "https://example.com/new_video", work.video_url
    assert_equal "#updated", work.tags

    assert_difference("Work.count", -1) do
      delete admin_work_url(work)
    end

    assert_redirected_to admin_works_url
  end

  test "authenticated user cannot create a work with unsafe video_url scheme" do
    sign_in_as(@user)

    assert_no_difference("Work.count") do
      post admin_works_url, params: {
        work: {
          title: "Unsafe Work",
          video_url: "javascript:alert(1)",
          tags: "#animation",
          description: "sample description"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "must be a valid HTTP or HTTPS URL"
  end

  private
    def sign_in_as(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
      assert_redirected_to root_url
    end
end
