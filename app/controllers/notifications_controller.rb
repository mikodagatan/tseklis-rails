class NotificationsController < ApplicationController
  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true

    if params[:join_company] == true
      redirect_to company_url(@notification.employment.company)
    else
      redirect_to user_employment_leave_request_url(@notification.employment.user, @notification.employment, @notification.leave_request)
    end
  end

  def notificiation_index
  end
end
