class TimeRequestsController < ApplicationController
  def new
    @company = Company.find(params[:company_id])
    @employment = Employment.where(user: current_user, company: @company).last
    @time_request = TimeRequest.new
  end

  def create
    @company = Company.find(params[:company_id])
    @employment = Employment.where(user: current_user, company: @company).last
    @time_request = TimeRequest.new(time_request_params)
    @time_request.employment_id = @employment.id
    if @time_request.save
      flash[:success] = "Registered your #{@time_request.in_out} request."
      redirect_to company_url(@company)
    else
      flash[:alert] = @time_request.errors.full_message
      render action: :new
    end
  end

  def show

  end

  def edit
    @company = Company.find(params[:company_id])
    @employment = Employment.where(user: current_user, company: @company).last
    @time_request = TimeRequest.find(params[:id])
  end

  def update
    @company = Company.find(params[:company_id])
    @employment = Employment.where(user: current_user, company: @company).last
    @time_request = TimeRequest.find(params[:id])
    if @time_request.update_attributes(time_request_params)
      flash[:success] = 'Time request Updated'
      redirect_to company_url(@company)
    else
      flash[:alert] = @time_request.errors.full_message
    end
  end

  def destroy

  end

  def index
    @company = Company.find(params[:company_id])
    if params[:date].present?
      @month ||= params[:date][:month].to_i
      @year ||= params[:date][:year].to_i
      @date = Date.new(@year, @month)
    else
      @date = Time.zone.now
    end
    @date_string = @date.strftime('%B %Y')
    @time_requests = TimeRequest.joins(:employment).where(employments: {company: @company}).where(date: @date.all_month)

  end

  def excel_export
    @company = Company.find(params[:company_id])
    if params[:year].present?
      @month ||= params[:month].to_i
      @year ||= params[:year].to_i
      @date = Date.new(@year, @month)
    else
      @date = Time.zone.now
    end
    @time_requests = TimeRequest.joins(:employment).where(employments: {company: @company}).where(date: @date.all_month)

    respond_to do |format|
      format.xlsx
    end
  end

  private

  def time_request_params
     params.require(:time_request).permit(
       :title,
       :in_out,
       :time,
       :date,
       :employment_id
     )
  end
end
