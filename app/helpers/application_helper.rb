module ApplicationHelper
  def image_variant_or_original(attachment, resize_to_limit:)
    return attachment unless attachment.attached?
    return attachment unless attachment.blob.image?
    return attachment unless variant_processing_available?

    attachment.variant(resize_to_limit: resize_to_limit)
  rescue StandardError => error
    Rails.logger.warn("ActiveStorage variant fallback to original: #{error.class} #{error.message}")
    attachment
  end

  private
    def variant_processing_available?
      @variant_processing_available ||= begin
        case Rails.application.config.active_storage.variant_processor
        when :vips
          begin
            require "vips"
            true
          rescue LoadError
            false
          end
        when :mini_magick
          begin
            require "mini_magick"
            MiniMagick::Utilities.which("magick").present? || MiniMagick::Utilities.which("convert").present?
          rescue LoadError
            false
          end
        else
          false
        end
      end
    end
end
