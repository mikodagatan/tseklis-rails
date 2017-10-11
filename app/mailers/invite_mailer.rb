class InviteMailer < ApplicationMailer

  def new_user_invite(invite, url)
    @invite = invite
    @url  = url
    @sender = User.find(invite.sender_id)
    mail(to: @invite.email, subject: @sender.profile.first_name + " " + @sender.profile.last_name + " invites you to use Tseklis" )
  end

  def existing_user_invite(invite)
    @invite = invite
    @sender = User.find(invite.sender_id)
    mail(to: @invite.email, subject: @sender.profile.first_name + " " + @sender.profile.last_name + " invites you to join " + @invite.company.name )
  end


end
