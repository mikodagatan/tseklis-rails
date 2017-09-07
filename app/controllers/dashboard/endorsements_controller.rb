class Dashboard::EndorsementsController < Dashboard::ResourceController

  def endorsement_params
  	params.require(:endorsement).permit(
            :id,
            :name,
            :photo,
            :link,
            :award_name,
            :rating,
            :description,
            )
  end
end
