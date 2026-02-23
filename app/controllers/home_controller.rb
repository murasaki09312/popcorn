class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    @works = Work.with_attached_thumbnail.order(created_at: :desc)
    @site_setting = SiteSetting.instance
    @line_url = @site_setting.safe_external_url(:line_url)
    @instagram_url = @site_setting.safe_external_url(:instagram_url)
    @youtube_url = @site_setting.safe_external_url(:youtube_url)
  end
end
