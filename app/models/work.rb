class Work < ApplicationRecord
  has_one_attached :thumbnail

  validates :title, presence: true
  validate :video_url_must_be_http_or_https

  def safe_video_url
    return if video_url.blank?

    uri = URI.parse(video_url)
    return unless uri.is_a?(URI::HTTP) && uri.host.present?

    uri.to_s
  rescue URI::InvalidURIError
    nil
  end

  def thumbnail_variant(resize_to_limit:)
    return unless thumbnail.attached?
    return thumbnail unless thumbnail.variable?

    thumbnail.variant(resize_to_limit: resize_to_limit)
  end

  private
    def video_url_must_be_http_or_https
      return if video_url.blank? || safe_video_url.present?

      errors.add(:video_url, "must be a valid HTTP or HTTPS URL")
    end
end
