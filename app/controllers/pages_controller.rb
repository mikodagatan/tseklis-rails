class PagesController < ApplicationController
	before_action :set_up

  def home
  	if user_signed_in?
			@companies = @current_user.companies.distinct if employed?
			@companies_accepted = @companies.where('employments.acceptance = true').distinct if employed?
			@connections = Employment.select('DISTINCT (user_id, company_id)').count
      # has_leave_types
      if @current_user.employed?
        count = 0
        @companies.each { |u| u.leave_types.count > 0 ? count += u.leave_types.count : count += 0}
        @has_leave_types = count > 1
				count2 = 0
				@companies.each { |u| u.leave_requests.where('employments.user_id = ?', @current_user.id).count > 0 ? count2 += 1 : count2 += 0 }
				@has_leave_requests = count2 > 0
				count3 = 0
				@companies.each { |u| u.employments.where(user_id: @current_user.id).where(acceptance: true).count > 0 ? count3 += 1 : count3 += 0}
				@accepted = count3 > 0
				@company_search = Company.search(params[:search])
				@current_employment = Employment.where(user_id: @user, company_id: @company, acceptance: true).first
      end
		end
    @features = Feature.all.where("features.active = true")
    @testimonials = Testimonial.all.where('testimonials.active = true')
    @endorsements = Endorsement.all.where('endorsements.active = true')
    @landing_page_settings = LandingPageSetting.last

		# dashboard logic from companies show

		if user_signed_in? && @user.employments.present?

			@year_search = params[:leave_data_year].to_s.to_i
			@year_search = Time.zone.today.strftime('%Y').to_i if @year_search == 0

			if params[:month_used].nil?
				@leave_data = @company.employments.includes(:leave_amounts)
					.where('leave_amounts.date between ? and ?', Time.zone.today.at_beginning_of_month, Time.zone.today.at_end_of_month)
					.where('leave_requests.acceptance = ?', true)
					.references(:leave_amounts)
			elsif params[:month_used].to_s.to_i == 0
				@leave_data = @company.employments.includes(:leave_amounts)
					.where('leave_amounts.date between ? and ?', Date.new(@year_search).at_beginning_of_year, Date.new(@year_search).at_end_of_year)
					.where('leave_requests.acceptance = ?', true)
					.references(:leave_amounts)
			else
				@leave_data = @company.employments.includes(:leave_amounts)
					.where('leave_amounts.date between ? and ?', Date.new(@year_search, params[:month_used].to_s.to_i).at_beginning_of_month, Date.new(@year_search, params[:month_used].to_s.to_i).at_end_of_month)
					.where('leave_requests.acceptance = ?', true)
					.references(:leave_amounts)
			end

			@months = [{Year: 0}, {January: 1}, {February: 2}, {March: 3}, {April: 4}, {May: 5}, {June: 6}, {July: 7}, {August: 8}, {September: 9}, {October: 10}, {November: 11 }, {December: 12 }]

			@remaining = @company.users


		end

		# manager subordinates

		if user_signed_in? && @current_employment.present?
			@subordinates = @current_employment.subordinates
				.where(end_date: nil, acceptance: true)
			@subordinate_leave_requests = LeaveRequest.where(employment_id: @subordinates.ids).reverse_order
			@subordinate_leave_requests = Kaminari.paginate_array(@subordinate_leave_requests).page(params[:lr_page_manager_dashboard]).per(@per_show)
		end

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
		if @user.employments.present?
			@employment = @user.employments.where(acceptance: true).first
			@employments = @user.employments
			@company = @employment.company
		end
	end
end
