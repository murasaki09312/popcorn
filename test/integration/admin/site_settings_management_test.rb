require "test_helper"

class Admin::SiteSettingsManagementTest < ActionDispatch::IntegrationTest
  setup do
    User.where(email_address: "admin@example.com").delete_all
    @user = User.create!(email_address: "admin@example.com", password: "password")
  end

  test "redirects unauthenticated users to sign-in page" do
    get edit_admin_site_setting_url

    assert_redirected_to new_session_url
  end

  test "authenticated user can update site settings" do
    sign_in_as(@user)
    setting = SiteSetting.instance

    patch admin_site_setting_url, params: {
      site_setting: {
        about_text: "Updated about text",
        contact_text: "Updated contact text",
        instagram_url: "https://instagram.com/popcorn",
        youtube_url: "https://youtube.com/@popcorn",
        line_url: "https://line.me/ti/p/example",
        about_image: fixture_file_upload("thumbnail.jpg", "image/jpeg")
      }
    }

    assert_redirected_to edit_admin_site_setting_url
    assert_equal "Updated about text", setting.reload.about_text
    assert_equal "Updated contact text", setting.contact_text
    assert_equal "https://instagram.com/popcorn", setting.instagram_url
    assert setting.about_image.attached?
  end

  private
    def sign_in_as(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
      assert_redirected_to root_url
    end
end
