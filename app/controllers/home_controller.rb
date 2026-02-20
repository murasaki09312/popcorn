class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    @works = Work.with_attached_thumbnail.order(created_at: :desc)
    @line_url = ENV.fetch("SITE_LINE_URL", "#")
    @instagram_url = ENV.fetch("SITE_INSTAGRAM_URL", "#")
    @youtube_url = ENV.fetch("SITE_YOUTUBE_URL", "#")
  end
end
