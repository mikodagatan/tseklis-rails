class LeaveRequestMailer < ApplicationMailer

  def lr_created(lr, sender, recipient, employment)
    @leave_request = lr
    @sender = sender
    @recipient = recipient
    @employment = employment
    mail(to: @recipient.email, subject: "Tseklis | " + @sender.full_name + " made a Leave Request for your approval. Title: " + @leave_request.title )
  end

end
