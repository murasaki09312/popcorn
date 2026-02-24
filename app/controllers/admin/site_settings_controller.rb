module Admin
  class SiteSettingsController < BaseController
    before_action :set_site_setting

    def edit
    end

    def update
      if @site_setting.update(site_setting_params)
        redirect_to edit_admin_site_setting_path, notice: "サイト設定を更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_site_setting
        @site_setting = SiteSetting.instance
      end

      def site_setting_params
        params.require(:site_setting).permit(
          :about_text,
          :contact_text,
          :instagram_url,
          :youtube_url,
          :line_url,
          :about_image,
          :logo_image
        )
      end
  end
end
