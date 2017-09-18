class PagesController < ApplicationController
	before_action :set_up

  def home
  	if user_signed_in?
			@companies = @current_user.companies.distinct if @current_user.companies.present?
			@connections = Employment.select('DISTINCT (user_id, company_id)').count
      # has_leave_types
      if @current_user.employed?
        count = 0
        @companies.each { |u| u.leave_types.count > 0 ? count += u.leave_types.count : count += 0}
        @has_leave_types = count > 1 ? true : false
      end
		end
    @features = Feature.all.where("features.active = true")
    @testimonials = Testimonial.all.where('testimonials.active = true')
    @endorsements = Endorsement.all.where('endorsements.active = true')
    @landing_page_settings = LandingPageSetting.last
  end

  def about
  end

  def team
    @owners = Owner.all.where('owners.active = true')
  end

end

private

def set_up
	if user_signed_in?
		@user = current_user
		@employment = @user.employments.last
		@employments = @user.employments
	end
end
