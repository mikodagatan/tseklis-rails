class Dashboard::RolesController < Dashboard::ResourceController
  def role_params
  params.require(:role).permit(
          :id,
          :name,
          )
  end
end
