class NotificationsController < ApplicationController
  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true

    if params[:join_company] == 'true'
      redirect_to company_url(@notification.employment.company) + "#user-table-anchor"
    else
      redirect_to user_employment_leave_request_url(@notification.employment.user, @notification.employment, @notification.leave_request)
    end
  end

  def read_all
    @notifications = current_user.notifications
    @notifications.update_all(read: true)
    redirect_back(fallback_location: request.referrer)
  end

  def notificiation_index
  end
end
