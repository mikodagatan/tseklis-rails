class InviteMailer < ApplicationMailer

  def new_user_invite(invite, url)
    @invite = invite
    @url  = url
    @sender = User.find(invite.sender_id)
    mail(to: @invite.email, subject: @sender.profile.first_name + " " + @sender.profile.last_name + " is inviting you to Tseklis" )
  end

end
