require "application_system_test_case"

class AdminAuthenticationTest < ApplicationSystemTestCase
  setup do
    User.where(email_address: "admin@example.com").delete_all
    User.create!(email_address: "admin@example.com", password: "password")
  end

  test "admin can sign in from the login screen" do
    visit new_session_path

    fill_in "Email address", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_current_path root_path
    assert_text "works"
  end

  test "top page is accessible without authentication" do
    visit root_path

    assert_current_path root_path
    assert_text "works"
  end
end
