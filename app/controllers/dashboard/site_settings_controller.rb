class Dashboard::SiteSettingsController < Dashboard::ResourceController

  def create
    site_setting = SiteSetting.new(site_setting_params)
    if site_setting.save
      redirect_to edit_dashboard_site_setting_url(site_setting)
    else
      render action: :new
    end
  end

  def site_setting_params
    params.require(:site_setting).permit(
          :id,
          :site_name,
          :site_description,
          :site_icon,
          :site_logo,
          )
  end
end
