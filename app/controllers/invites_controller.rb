class InvitesController < ApplicationController

  def new
    @company = Company.find(params[:company_id])
    @invite = @company.invites.build
    @current_user = current_user
  end

  def create
    @company = Company.find(params[:company_id])
    @invite = Invite.new(invite_params)
    @invite.company = @company
    @invite.sender = current_user
    if @invite.save
        #if the user already exists
      if @invite.recipient != nil
        #send a notification email
        if @invite.recipient.employments.where(company_id: @invite.company_id).blank?
          InviteMailer.existing_user_invite(@invite).deliver
          @employment = Employment.new(
  												company: @invite.company,
  												user: @invite.recipient,
  												role_id: @employee.id,
  												start_date: @invite.start_date,
  												acceptance: true,
  												acceptor_id: @invite.sender_id
  											).save!
          flash[:success] = "Invitation sent to " + @invite.email
          render action: :new
        else
          flash[:alert] = "Employee already part of " + @invite.company.name
          render action: :new
        end
      else
        InviteMailer.new_user_invite(@invite,
          new_user_registration_path(invite_token: @invite.token, email: @invite.email, start_date: @invite.start_date, first_name: @invite.first_name, last_name: @invite.last_name)).deliver_now
        flash[:success] = "Invitation sent to " + @invite.email
        render action: :new
      end
    else
      render action: :new
    end
  end

  def edit

  end

  def update

  end

  private

  def invite_params
  	params.require(:invite).permit(
  		:id,
      :email,
      :company_id,
      :sender_id,
      :recipient_id,
      :token,
      :first_name,
      :last_name,
      :start_date
  		)
  end
end
