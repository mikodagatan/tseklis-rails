class Dashboard::OwnersController < Dashboard::ResourceController
  def owner_params
    params.require(:owner).permit(
            :id,
            :name,
            :photo,
            :video,
            :quote,
            :designation,
            :description,
            :active,
            )
  end
end
