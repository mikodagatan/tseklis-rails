class RejectionMessagesController < ApplicationController

  before_action :set_up

  def new
    @rejection_message = @leave_request.build_rejection_message
  end

  def create
    @rejection_message = @leave_request.build_rejection_message(rejection_message_params)
    if @rejection_message.save
      @leave_request.update(acceptance: false, acceptor_id: current_user.id)
      redirect_to user_employment_leave_request_url(@user,@employment, @leave_request)
    else
      render action: :new
    end
  end

  def edit
    @rejection_message =
    RejectionMessage.find(params[:id])
  end

  def update
    @rejection_message =
    RejectionMessage.find(params[:id])
    if @rejection_message.update_attributes(rejection_message_params)
      redirect_to user_employment_leave_request_url(@leave_request)
    else
      render action: :new
    end

  end

  private

  def set_up
    @user = User.find(params[:user_id])
    @employments = @user.employments
    @employment = @user.employments.find(params[:employment_id])
    @company = @employment.company
    @companies = @user.companies
    @leave_request = @employment.leave_requests.find_by_id( params[:leave_request_id] )

  end

  def rejection_message_params
    params.require(:rejection_message).permit(
      :id,
      :description,
      :leave_request_id
    )
  end


  def leave_request_params
    params.require(:leave_request).permit(
      :id,
      :title,
      :description,
      :start_date,
      :start_time,
      :end_date,
      :end_time,
      :acceptance,
      :acceptor_id,
      :allow_weekend_holiday_leave,
      :leave_type_id,
      :employment_id,
      rejection_message_attributes: [
        :id,
        :description,
        :leave_request_id
        ]
      )
  end
end
