class Dashboard::PlansController < Dashboard::ResourceController
  def plan_params
    params.require(:plan).permit(
            :id,
            :name,
            :photo,
            :video,
            :price,
            :description,
            :active,
            )
  end
end
