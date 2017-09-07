class Dashboard::TestimonialsController < Dashboard::ResourceController
  def testimonial_params
    params.require(:testimonial).permit(
          :id,
          :name,
          :company_name,
          :photo,
          :video,
          :description,
          :active,
          )
  end
end
