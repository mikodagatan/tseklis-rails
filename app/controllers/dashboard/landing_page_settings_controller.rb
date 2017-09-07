class Dashboard::LandingPageSettingsController < Dashboard::ResourceController
  def landing_page_settings_params
  	params.require(:landing_page_settings).permit(
            :id,
            :photo_1,
            :photo_2,
            :photo_3,
            :photo_4,
            :video_1,
            :video_2,
            :video_3,
            :video_4,
            :call_to_action_background,
            :header_message,
            :subheader_message,
            :endorsement_header,
            :endorsement_description,
            :testimonial_header,
            :testimonial_description
            :short_description,
            :long_description,
            :active,
            )
  end
end
