class Dashboard::FeaturesController < Dashboard::ResourceController
  def feature_params
  	params.require(:feature).permit(
            :id,
            :name,
            :photo,
            :video,
            :short_description,
            :long_description,
            :active,
            )
  end
end
