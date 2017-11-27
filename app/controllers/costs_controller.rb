class CostsController < ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @costs = Cost.where(company_id: @company.id)
  end

end
