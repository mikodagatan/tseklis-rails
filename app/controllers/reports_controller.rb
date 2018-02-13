class ReportsController < ApplicationController
  before_action :set_up

  def index

  end

  def remaining_leaves
    @r_date = re_params[:date_as_of].to_date unless params[:re].blank?
    @remaining = User.joins(:employments).where(employments: {company: @company, end_date: nil})
    unless @r_date.blank?
      @remaining = User.joins(:employments).where(employments: {company: @company}).where('employments.end_date <= ? or employments.end_date is ?', @r_date, nil)
    end
  end

  def set_up
    @company = Company.find(params[:company_id])
  end

  protected

	def re_params
		params.require(:re).permit(:date_as_of)
	end

end
