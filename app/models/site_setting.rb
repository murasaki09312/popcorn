require "uri"

class SiteSetting < ApplicationRecord
  DEFAULT_ABOUT_TEXT = <<~TEXT.squish.freeze
    トラックメイカーmiyuとアニメーションデザイナーhinからなる、クリエイティブユニット。
    音と映像を軸に、MV・SNSコンテンツ・ブランドビジュアルを制作しています。
  TEXT
  DEFAULT_CONTACT_TEXT = "ご相談・ご依頼はLINEからお気軽にご連絡ください。".freeze

  has_one_attached :about_image
  has_one_attached :logo_image

  validates :about_text, presence: true
  validates :contact_text, presence: true
  validates :singleton_guard, inclusion: { in: [ 0 ] }
  validate :validate_external_urls
  validate :single_record_limit, on: :create

  before_validation :set_singleton_guard

  def self.instance
    first_or_create! do |setting|
      setting.about_text = DEFAULT_ABOUT_TEXT
      setting.contact_text = DEFAULT_CONTACT_TEXT
    end
  end

  def safe_external_url(attribute_name)
    value = public_send(attribute_name)
    return "#" if value.blank?
    return value if http_url?(value)

    "#"
  end

  private
    def set_singleton_guard
      self.singleton_guard = 0
    end

    def single_record_limit
      return unless self.class.where.not(id: id).exists?

      errors.add(:base, "Site settings can only have one record")
    end

    def validate_external_urls
      %i[instagram_url youtube_url line_url].each do |attribute_name|
        value = public_send(attribute_name)
        next if value.blank?

        errors.add(attribute_name, "must be a valid http/https URL") unless http_url?(value)
      end
    end

    def http_url?(value)
      uri = URI.parse(value)
      uri.is_a?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      false
    end
end
