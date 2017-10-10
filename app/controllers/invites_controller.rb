class InvitesController < ApplicationController

  def new
    @company = Company.find(params[:company_id])
    @invite = @company.invites.build
  end

  def create
    @company = Company.find(params[:company_id])
    @invite = Invite.new(invite_params)
    @invite.company = @company
    @invite.sender = current_user
    if @invite.save
      InviteMailer.new_user_invite(@invite,
        new_user_registration_path(invite_token: @invite.token)).deliver_now
      flash[:success] = "Invitation sent to " + @invite.email
      # redirect_to company_invite_path(@company)
      render action: :new
    else
      # flash[:alert] = "Invitation failed to send"
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
      :token
  		)
  end
end
