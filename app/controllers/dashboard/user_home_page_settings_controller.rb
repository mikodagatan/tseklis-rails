class Dashboard::UserHomePageSettingsController < Dashboard::ResourceController
  def user_home_page_setting_params
    params.require(:user_home_page_setting).permit(
          :id,
          :create_company_photo,
          :connect_company_photo,
          :company_settings_photo,
          )
  end
end
