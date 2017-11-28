class CostsController < ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @costs = Cost.where(company_id: @company.id).start_date_order
  end

  def new
    @company = Company.find(params[:company_id])
    @cost = Cost.new
  end

  def create
    @company = Company.find(params[:company_id])
    @cost = Cost.new(cost_params)
    if @cost.save
      flash[:success] = "Costs are saved!"
      redirect_to company_costs_url(@company)
    else
      flash[:alert] = "Costs are not saved"
      render action: :new
    end
  end

  private

  def cost_params
    params.require(:cost).permit(
      :id,
      :employment_id,
      :company_id,
      :salary,
      :overhead,
      :company_id,
      :employment_id,
      :start_date,
      :end_date
    )
  end
end
