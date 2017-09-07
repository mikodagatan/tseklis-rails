class Dashboard::SiteSettingsController < Dashboard::ResourceController
  def site_settings_params
    params.require(:site_settings).permit(
          :id,
          :site_name,
          :site_description,
          :site_icon,
          :site_logo,
          )
  end
end
