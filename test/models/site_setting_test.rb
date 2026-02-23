require "test_helper"

class SiteSettingTest < ActiveSupport::TestCase
  test "instance creates and reuses a single record" do
    SiteSetting.delete_all

    first = SiteSetting.instance
    second = SiteSetting.instance

    assert_equal first.id, second.id
    assert_equal 1, SiteSetting.count
  end

  test "rejects non-http url schemes" do
    setting = SiteSetting.instance
    setting.instagram_url = "javascript:alert(1)"

    assert_not setting.valid?
    assert_includes setting.errors[:instagram_url], "must be a valid http/https URL"
  end

  test "prevents creating a second record" do
    SiteSetting.instance
    second = SiteSetting.new(about_text: "x", contact_text: "y")

    assert_not second.valid?
    assert_includes second.errors[:base], "Site settings can only have one record"
  end
end
